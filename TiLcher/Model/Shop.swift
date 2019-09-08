import Foundation

struct Coordinate: Codable, Equatable {
    let latitude: Double
    let longitude: Double
}

struct Shop: Codable, Equatable {
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

    enum DigitalStatus: String, Codable, Equatable {
        case online, offline
    }

    struct Place: Codable, Equatable {
        let id: Int
        let point: Coordinate
        let address: String
    }

    static let mock = Shop(
        id: 11111,
        name: "Forest",
        instagramUsername: "forest_store_krd",
        type: .offline,
        goodsCategories: [],
        shopCategories: [],
        locations: [],
        image: RemoteImage(
            id: "",
            url: ""
        )
    )
}
