import PromiseKit

struct ShopCategory: Codable, Equatable {
    let id: Int
    let value: String
    let displayValue: String
}

struct GoodsCategory: Codable, Equatable {
    let id: Int
    let value: String
    let displayValue: String
}

struct Assignment: Codable {
    let id: Int
    let cashback: Int
    let points: Int
    var status: ShopAssignment.Stage
}

final class ShopsService {
    private let api = API<ShopsAssignmentEndpoint>()

    private let keychainService: KeychainServiceProtocol

    init(
        keychainService: KeychainServiceProtocol
    ) {
        self.keychainService = keychainService
    }

    var token: String {
        guard let token = keychainService.fetchAccessToken() else {
                fatalError("Should be set")
        }
        return token
    }

    func get() -> Promise<ListPageResponse<Shop>> {
        return api.request(endpoint: .get(token: token))
    }

    func getShopAssignments() -> Promise<ListPageResponse<ShopAssignment>> {
        return api.request(endpoint: .getAssigned(token: token))
    }

    func accept(assignment: ShopAssignment) -> Promise<Void> {
        return Promise<Void> { seal in
            api.request(
                endpoint: .acceptAssignment(id: assignment.assignment.id, token: token)
            ) { response in
                switch response.result {
                case .failure(let error):
                    seal.reject(error)
                case .success:
                    seal.fulfill(())
                }
            }
        }
    }

    func complete(assignment: ShopAssignment, shopReviewResult: ShopReviewResults) -> Promise<Void> {
        return Promise<Void> { seal in
            api.request(
                endpoint: .completeAssignment(
                    id: assignment.assignment.id,
                    shopReviewResults: shopReviewResult,
                    token: token
                )
            ) { response in
                switch response.result {
                case .failure(let error):
                    seal.reject(error)
                case .success:
                    seal.fulfill(())
                }
            }
        }
    }
}
