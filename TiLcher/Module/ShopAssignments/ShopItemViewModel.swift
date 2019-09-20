import Foundation

struct ShopItemViewModel {
    let name: String
    let type: String
    let imageUrl: URL?
    let pointsForLook: String
}

extension ShopItemViewModel {
    init(shopReview: ShopAssignment) {
        self.init(
            name: shopReview.shop.name,
            type: (shopReview.shop.goodsCategories
                .compactMap { $0.displayValue })
                .joined(separator: "/")
                .lowercased(),
            imageUrl: shopReview.shop.imageUrl,
            pointsForLook: "\(shopReview.assignment.points)"
        )
    }
}
