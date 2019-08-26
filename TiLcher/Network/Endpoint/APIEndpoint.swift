import Alamofire

public typealias Method = Alamofire.HTTPMethod

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: Method { get }
    var headers: [String: String] { get }
    var parameters: [String: Any] { get }
    var encoding: ParameterEncoding { get }
}
