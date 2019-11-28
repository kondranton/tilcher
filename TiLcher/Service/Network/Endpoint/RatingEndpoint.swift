import Alamofire

enum RatingEndpoint {
    case getStylists
}

extension RatingEndpoint: APIService {
    var baseURL: URL {
        guard let url = URL(string: Environment.current.baseURL + "stylist/users/") else {
            fatalError("URL should be valid")
        }
        return url
    }

    var path: String {
        return "ranked/"
    }

    var method: Method {
        return .get
    }

    var headers: [String: String] {
        return [:]
    }

    var parameters: [String: Any] {
        return [:]
    }

    var encoding: ParameterEncoding {
        return URLEncoding.default
    }

    var requiresAuthorization: Bool {
        return true
    }
}
