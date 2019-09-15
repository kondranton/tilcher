import Foundation

struct ListPageResponse<Item: Codable>: Codable {
    let next: String?
    let previous: String?
    let results: [Item]
}
