import Foundation
import Alamofire

enum ShopsEndpoint {
    case getAssigned(token: String)
    case acceptAssignment(id: Int, token: String)
    case completeAssignment(id: Int, shopReviewResults: ShopReviewResults, token: String)
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
        case .getAssigned:
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
        case .getAssigned(let token), .acceptAssignment(_, let token),
             .completeAssignment(_, _, let token):
            return [
                "Authorization": "JWT \(token)"
            ]
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .getAssigned:
            return [:]
        case .acceptAssignment(let id, _):
            return [
                "shop_assignment_id": id
            ]
        case .completeAssignment(let id, let results, _):
            return [
                "shop_assignment_id": id,
                "looks_count": results.looks,
                "collages_count": results.collages,
                "stories_count": results.stories,
                "posts_count": results.posts
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
