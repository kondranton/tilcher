import Foundation
import Alamofire

enum AuthorizationEndpoint {
    case requestCode(phone: String)
    case verify(code: String, verificationPackage: AuthVerificationPackage)
    case signup(user: NewUserProfile, verificationPackage: AuthVerificationPackage)
}

extension AuthorizationEndpoint: APIEndpoint {
    var baseURL: URL {
        guard let url = URL(string: Environment.current.baseURL + "auth") else {
            fatalError("URL should be valid")
        }
        return url
    }

    var path: String {
        switch self {
        case .requestCode:
            return "/send_phone_code/"
        case .verify:
            return "/verify_phone_code/"
        case .signup:
            return "/signup/"
        }
    }

    var method: Method {
        return .post
    }

    var headers: [String: String] {
        return [:]
    }

    var parameters: [String: Any] {
        switch self {
        case let .requestCode(phone):
            return [
                "phone": phone,
                "should_send_sms": Environment.current.shouldSendSMS
            ]
        case let .verify(code, package):
            return [
                "code": code,
                "verification_id": package.verificationID,
                "phone": package.phone
            ]
        case let .signup(user, package):
            return [
                "name": user.name,
                "type": user.type.rawValue,
                "instagram_username": user.instagramUsername,
                "verification_id": package.verificationID
            ]
        }
    }

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
