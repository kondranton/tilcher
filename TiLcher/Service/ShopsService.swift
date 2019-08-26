import PromiseKit

final class ShopsService {
    private let api = API<ShopsEndpoint>()

    private let keychainService: KeychainServiceProtocol

    init(
        keychainService: KeychainServiceProtocol
    ) {
        self.keychainService = keychainService
    }
}
