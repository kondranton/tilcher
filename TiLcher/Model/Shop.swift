import Foundation

struct Coordinate: Codable, Equatable {
    let latitude: Double
    let longitude: Double
}

struct Shop: Codable {
    let id: Int
    let name: String
    let instagramUsername: String
    let type: DigitalStatus
    let goodsCategories: [GoodsCategory]
    let shopCategories: [GoodsCategory]
    let locations: [Place]
    let image: RemoteImage?

    var imageUrl: URL? {
        return (image?.url).flatMap(URL.init)
    }

    enum DigitalStatus: String, Codable {
        case online, offline
    }

    struct Place: Codable, Equatable {
        let id: Int
        let point: Coordinate
        let address: String
    }
}

//struct Shop {
//    struct Place: Equatable {
//        let location: Coordinate
//        let address: String
//    }
//
//    enum DigitalStatus: String, Codable {
//        case online, offline
//    }
//
//    let name: String
//    let type: String
//    let clothesType: String
//    let instagram: String
//    let places: [Place]
//    let digitalStatus: DigitalStatus
//    let image: RemoteImage?
//
//    var imageUrl: URL? {
//        return (image?.url).flatMap(URL.init)
//    }
//}
