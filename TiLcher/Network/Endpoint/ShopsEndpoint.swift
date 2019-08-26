import Foundation
import Alamofire

enum ShopsEndpoint {
    case getAssigned(page: Int, token: String)
    case acceptAssignment(id: String, token: String)
    case completeAssignment(id: String, token: String)
}

extension ShopsEndpoint: APIEndpoint {
    var baseURL: URL {
        guard let url = URL(string: "https://tilcher-stage.herokuapp.com/api/v1/stylist/shops") else {
            fatalError("URL should be valid")
        }
        return url
    }

    var path: String {
        switch self {
        case .getAssigned(let page, _):
            return "/assigned/"
        case .acceptAssignment:
            return "/accept_assignment/"
        case .completeAssignment:
            return "/complete_assignment/"
        }
    }

    var method: Method {
        switch self {
        case .getAssigned:
            return .get
        case .acceptAssignment, .completeAssignment:
            return .post
        }
    }

    var headers: [String: String] {
        switch self {
        case .getAssigned(_, let token), .acceptAssignment(_, let token),
             .completeAssignment(_, let token):
            return [
                "Authorization": "JWT \(token)"
            ]
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .getAssigned:
            return [:]
        case .acceptAssignment(let id, _), .completeAssignment(let id, _):
            return [
                "shop_assignment_id": id
            ]
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .getAssigned:
            return URLEncoding.default
        case .acceptAssignment, .completeAssignment:
            return JSONEncoding.default
        }
    }
}
