import Foundation

struct StylistProfile: Codable {
    struct Statistics: Codable {
        let looksPoints: Int
        let postsPoints: Int
        let shopsPoints: Int
        let totalPoints: Int

        let looksCount: Int
        let publicationsCount: Int
        let shopsCount: Int
    }

    struct Payment: Codable {
        private let pendingPayment: String

        var pending: Int {
            return Int(Double(pendingPayment) ?? 0)
        }

        init(pending: Int) {
            self.pendingPayment = "\(pending)"
        }
    }

    let id: Int
    let phone: String
    let name: String
    let type: UserRole
    let reviewStatus: UserReviewStatus
    let instagramUsername: String?
    let pointsData: Statistics?
    var payment: Payment
    var profilePhoto: RemoteImage?
}
