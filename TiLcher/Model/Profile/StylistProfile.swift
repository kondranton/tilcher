import Foundation

struct StylistProfile: Codable {
    struct Statistics: Codable {
        let looks: Int
        let instagramPosts: Int
        let shops: Int
        let clients: Int
        let invitedUsers: Int
    }

    struct Balance: Codable {
        let score: Int
        let cashback: Int
    }

    let id: Int
    let phone: String
    let name: String
    let type: UserRole
    let reviewStatus: UserReviewStatus
    let instagramUsername: String?
    let counts: Statistics?
    var balance: Balance
    var profilePhoto: RemoteImage?
}
