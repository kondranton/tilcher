import Foundation

struct ShopItemViewModel {
    let name: String
    let type: String
    let imagePath: String
    let pointsForLook: String

    var imageUrl: URL? {
        return URL(string: imagePath)
    }
}

extension ShopItemViewModel {
    init(shopReview: ShopAssignment) {
        self.init(
            name: shopReview.shop.name,
            type: shopReview.shop.clothesType,
            imagePath: shopReview.shop.imagePath,
            pointsForLook: "\(shopReview.rewards.pointsForLook)"
        )
    }
}
