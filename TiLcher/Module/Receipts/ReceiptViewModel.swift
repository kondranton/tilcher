import Foundation

struct ReceiptViewModel {
    let price: String
    let shop: String
    let date: String
    let commissionAbsolute: String
    let commissionRelative: String
    let photoURL: URL?
}

extension ReceiptViewModel {
    init(receipt: Receipt) {
        price = "\(receipt.total)р"
        shop = receipt.shop.name
        date = FormatterHelper.string(from: receipt.purchasedAt)
        let total = Double(receipt.total) ?? 1
        let comission = Double(receipt.shop.defaultCashback) / 100
        commissionAbsolute = "\(Int(total * comission))"
        commissionRelative = "кэшбек \(receipt.shop.defaultCashback)%"
        photoURL = receipt.receiptPhotos.first.flatMap { URL(string: $0.url) }
    }
}
