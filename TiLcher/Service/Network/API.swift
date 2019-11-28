import Alamofire
import PromiseKit

final class API<Endpoint: APIService> {
    typealias Result = Alamofire.Result
    typealias APIRequestCompletion = (Alamofire.DataResponse<Any>) -> Void

    private let keychainService: KeychainServiceProtocol

    init(
        keychainService: KeychainServiceProtocol = KeychainService()
    ) {
        self.keychainService = keychainService
    }

    func request<ResultType: Decodable>(endpoint: Endpoint, decoder: JSONDecoder? = nil) -> Promise<ResultType> {
        var headers = endpoint.headers
        if endpoint.requiresAuthorization, let token = keychainService.fetchAccessToken() {
            headers["Authorization"] = "JWT \(token)"
        }

        return Promise { seal in
            Alamofire.request(
                endpoint.baseURL.appendingPathComponent(endpoint.path),
                method: endpoint.method,
                parameters: endpoint.parameters,
                encoding: endpoint.encoding,
                headers: headers
            )
            .validate { request, response, data in
                if  400...600 ~= response.statusCode {
                    dump("validation failed for \(request?.url?.absoluteString ?? "") status code \(response.statusCode)")

                    let decoder = decoder ?? .common
                    guard
                        let data = data,
                        let errors = try? decoder.decode(APIErrors.self, from: data),
                        let error = errors.errors.first
                    else {
                        assertionFailure("Unhandled")
                        return .failure(UnknownError())
                    }

                    if error.code == "authentication_failed" || response.statusCode == 401 {
                        self.keychainService.clear()
                    }

                    return .failure(error)
                } else {
                    return .success
                }
            }
            .responseJSON { response in
                switch response.result {
                case .failure(let error):
                    seal.reject(error)
                case .success:
                    let decoder = JSONDecoder.common
                    guard let data = response.data else {
                        assertionFailure("No data")
                        return
                    }
                    do {
                        let mappedResponse = try decoder.decode(ResultType.self, from: data)
                        seal.fulfill(mappedResponse)
                    } catch {
                        assertionFailure(error.localizedDescription)
                    }
                }
            }
        }
    }

    func request(endpoint: Endpoint, completion: @escaping APIRequestCompletion) {
        Alamofire.request(
            endpoint.baseURL.appendingPathComponent(endpoint.path),
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: JSONEncoding.default,
            headers: endpoint.headers
        )
        .validate { _, response, data in
            if  400...600 ~= response.statusCode {
                let decoder = JSONDecoder()
                guard
                    let data = data,
                    let errors = try? decoder.decode(APIErrors.self, from: data),
                    let error = errors.errors.first
                else {
                    assertionFailure("Unhandled")
                    return .failure(UnknownError())
                }

                return .failure(error)
            } else {
                return .success
            }
        }
        .responseJSON(completionHandler: completion)
    }

    struct APIErrors: Codable {
        let errors: [APIError]
    }
}
