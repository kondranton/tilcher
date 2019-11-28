import Foundation

struct ParticipantViewModel {
    let position: String
    let name: String
    let points: Int
    let looks: String
    let publications: String
    let shops: String
    let imagePath: String?

    var imageURL: URL? {
        return imagePath.flatMap(URL.init)
    }
}
