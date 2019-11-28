import PromiseKit

struct Contest: Codable {
    let id: Int
    let endDate: Date

    enum CodingKeys: String, CodingKey {
        case id
        case endDate = "endDt"
    }
}

final class RatingService {
    private let api = API<RatingEndpoint>()
    private let contestAPI = API<ContestEndpoint>()

    func fetchOngoingContests() -> Promise<[Contest]> {
        let decoder = JSONDecoder.common
        decoder.dateDecodingStrategy = .iso8601
        let promise: Promise<ListPageResponse<Contest>> = self.contestAPI.request(
            endpoint: .getOngoing,
            decoder: decoder
        )
        return promise.map { $0.results }
    }

    func fetchRating() -> Promise<ListPageResponse<RankedStylist>> {
        return self.api.request(endpoint: .getStylists)
    }
}
