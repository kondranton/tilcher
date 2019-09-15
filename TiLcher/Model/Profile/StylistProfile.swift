import Foundation

struct StylistProfile: Codable {
    struct Statistics: Codable {
        let looksPoints: Int
        let postsPoints: Int
        let shopsPoints: Int
        let totalPoints: Int
    }

    struct Balance: Codable {
        let cashback: Int
    }

    let id: Int
    let phone: String
    let name: String
    let type: UserRole
    let reviewStatus: UserReviewStatus
    let instagramUsername: String?
    let pointsData: Statistics?
    var balance: Balance
    var profilePhoto: RemoteImage?
}
