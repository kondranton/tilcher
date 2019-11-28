import Alamofire

typealias Method = Alamofire.HTTPMethod

protocol APIService {
    var baseURL: URL { get }
    var path: String { get }
    var method: Method { get }
    var headers: [String: String] { get }
    var parameters: [String: Any] { get }
    var encoding: ParameterEncoding { get }
    var requiresAuthorization: Bool { get }
}
