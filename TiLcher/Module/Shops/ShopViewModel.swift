import Foundation

struct ShopViewModel {
    let name: String
    let imagePath: String?
    let isSelected: Bool

    var imageURL: URL? {
        return imagePath.flatMap(URL.init)
    }
}
