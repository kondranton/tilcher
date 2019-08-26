import Foundation

struct Verifier: Codable {
    let verificationID: String

    enum CodingKeys: String, CodingKey {
        case verificationID = "verificationId"
    }
}
