import Foundation
import Alamofire

enum ProfileEndpoint {
    case get(token: String)
    case update(profile: NewUserProfile, token: String)
}

extension ProfileEndpoint: APIEndpoint {
    var baseURL: URL {
        guard let url = URL(string: "https://tilcher-stage.herokuapp.com/api/v1/stylist/profile") else {
            fatalError("URL should be valid")
        }
        return url
    }

    var path: String {
        switch self {
        case .get:
            return "/self/"
        case .update:
            return "/self_update/"
        }
    }

    var method: Method {
        switch self {
        case .get:
            return .get
        case .update:
            return .patch
        }
    }

    var headers: [String: String] {
        switch self {
        case .get(let token), .update(_, let token):
            return [
                "Authorization": "JWT \(token)"
            ]
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .get:
            return [:]
        case let .update(profile, _):
            return [
                "name": profile.name,
                "instagram_username": profile.instagramUsername
            ]
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .get:
            return URLEncoding.default
        case .update:
            return JSONEncoding.default
        }
    }
}
