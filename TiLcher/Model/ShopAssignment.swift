struct ShopAssignment: Codable {
    let shop: Shop
    var assignment: Assignment

    enum Stage: String, Codable {
        //        assigned, assignment_accepted, completed_review_pending, completed_review_approved, completed_review_rejected
        case assigned
        case assignmentAccepted = "assignment_accepted"
        case completedPending = "completed_review_pending"
        case completedApproved = "completed_review_approved"
        case completedRejected = "completed_review_rejected"

        var actionTitle: String {
            switch self {
            case .assigned:
                return "Принять"
            case .assignmentAccepted:
                return "Завершить"
            case .completedPending:
                return "Отменить"
            case .completedApproved:
                return ""
            case .completedRejected:
                return "Переподать"
            }
        }
    }

    struct Rewards {
        let pointsForLook: Int
        let comission: Int
    }

    static let mock = ShopAssignment(
        shop: .mock,
        assignment: Assignment(
            id: 111,
            cashback: 10,
            points: 5,
            status: .assigned
        )
    )
}
