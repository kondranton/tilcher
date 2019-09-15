import Foundation
import PromiseKit

final class ReceiptService {
    private let api = API<ReceiptEndpoint>()

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

    func getReceipts() -> Promise<ListPageResponse<Receipt>> {
        return api.request(endpoint: .get(token: token))
    }

    func create(receipt: NewReceipt) -> Promise<Void> {
        return Promise { seal in
            api.request(
                endpoint: .create(token: token, bill: receipt)
            ) { result in
                switch result.result {
                case .success:
                    seal.fulfill(())
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
