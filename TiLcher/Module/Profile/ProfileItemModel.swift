import Foundation

enum ProfileItemModel {
    case header(ProfileHeaderItemModel)
    case statistics(ProfileStatisticsItemModel)
}

struct ProfileHeaderItemModel {
    let money: Int
    let points: Int
    let name: String
    let imagePath: String

    var imageURL: URL? {
        return URL(string: imagePath)
    }
}

struct ProfileStatisticsItemModel {
    enum ItemType {
        case looks
        case publications
        case shops
        case clients
        case usersInvited

        var name: String {
            switch self {
            case .looks:
                return "Луки"
            case .publications:
                return "Публикации в Инстаграм"
            case .shops:
                return "Магазины"
            case .clients:
                return "Клиенты"
            case .usersInvited:
                return "Привлеченные пользователи"
            }
        }

        var imageName: String {
            switch self {
            case .looks:
                return "look"
            case .publications:
                return "publication"
            case .shops:
                return "shop"
            case .clients:
                return "client"
            case .usersInvited:
                return "engaged_user"
            }
        }
    }

    let itemType: ItemType
    let value: Int
}
