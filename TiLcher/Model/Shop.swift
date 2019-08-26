import Foundation

struct Coordinate: Equatable {
    let latitude: Double
    let longitude: Double
}

struct Shop {
    struct Place: Equatable {
        let location: Coordinate
        let address: String
    }

    enum DigitalStatus {
        case online, offline
    }

    let name: String
    let type: String
    let clothesType: String
    let instagram: String
    let imagePath: String
    let places: [Place]
    let digitalStatus: DigitalStatus


    var imageUrl: URL? {
        return URL(string: imagePath)
    }
}
