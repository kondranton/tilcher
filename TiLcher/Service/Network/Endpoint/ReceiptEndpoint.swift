import Foundation
import Alamofire

enum ReceiptEndpoint {
    case get(token: String), create(token: String, bill: NewReceipt)
}

extension ReceiptEndpoint: APIEndpoint {
    var baseURL: URL {
        guard let url = URL(string: Environment.current.baseURL + "stylist/receipts/") else {
            fatalError("URL should be valid")
        }
        return url
    }

    var path: String {
        return ""
    }

    var method: Method {
        switch self {
        case .get:
            return .get
        case .create:
            return .post
        }
    }

    var headers: [String: String] {
        switch self {
        case .get(let token), .create(let token, _):
            return [
                "Authorization": "JWT \(token)"
            ]
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .get:
            return [:]
        case .create(_, let receipt):
            guard
                let date = receipt.date,
                let shopID = receipt.shop?.id,
                let total = receipt.money,
                let photoID = receipt.remoteImage?.id
            else {
                assertionFailure("Should be filled before sending")
                return [:]
            }

            return [
                "purchased_at": FormatterHelper.serverValue(from: date),
                "shop_id": shopID,
                "total": total,
                "receipt_photo_ids": [photoID]
            ]
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .get:
            return URLEncoding.default
        case .create:
            return JSONEncoding.default
        }
    }
}
