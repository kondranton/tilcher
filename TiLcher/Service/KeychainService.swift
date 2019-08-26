import KeychainAccess

protocol KeychainServiceProtocol {
    func write(token: String, phone: String)
    func clear()

    func hasToken() -> Bool
    func fetchAccessToken() -> String?
    func fetchPhone() -> String?
}

final class KeychainService: KeychainServiceProtocol {
    private enum Key {
        static let service = "com.tilcher.app"
        static let token = "access.token"
        static let phone = "access.phone"
    }

    private var keychain = Keychain(service: Key.service)

    func write(token: String, phone: String) {
        keychain[Key.token] = token
        keychain[Key.phone] = phone
    }

    func clear() {
        keychain[Key.token] = nil
        keychain[Key.phone] = nil
    }

    func hasToken() -> Bool {
        return (try? keychain.get(Key.token)) != nil
    }

    func fetchAccessToken() -> String? {
        if let token = try? keychain.get(Key.token) {
            return token
        }
        return nil
    }

    func fetchPhone() -> String? {
        if let phone = try? keychain.get(Key.phone) {
            return phone
        }
        return nil
    }
}

