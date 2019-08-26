import Alamofire
import PromiseKit

final class API<Endpoint: APIEndpoint> {
    public typealias Result = Alamofire.Result
    public typealias APIRequestCompletion = (Alamofire.DataResponse<Any>) -> Void

    struct APIErrors: Codable {
        let errors: [APIError]
    }

    func request<ResultType: Codable>(endpoint: Endpoint) -> Promise<ResultType> {
        return Promise { seal in
            Alamofire.request(
                endpoint.baseURL.appendingPathComponent(endpoint.path),
                method: endpoint.method,
                parameters: endpoint.parameters,
                encoding: endpoint.encoding,
                headers: endpoint.headers
            )
            .validate { _, response, data in
                if  400...600 ~= response.statusCode {
                    let decoder = JSONDecoder.common
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
                        assertionFailure("Bad data")
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
}
