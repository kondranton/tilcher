import Foundation
import PromiseKit

protocol ProfileServiceProtocol {
    func fetchProfile() -> Promise<StylistProfile>
    func updateProfile(data: EditableUserProfile) -> Promise<Void>
}

enum FetchProfileError: String, Error {
    case notApproved = "not_approved"
}

final class ProfileService: ProfileServiceProtocol {
    private let api = API<ProfileEndpoint>()

    private let keychainService: KeychainServiceProtocol
    private let persistanceService: PersistenceServiceProtocol

    init(
        keychainService: KeychainServiceProtocol,
        persistanceService: PersistenceServiceProtocol
    ) {
        self.keychainService = keychainService
        self.persistanceService = persistanceService
    }

    func fetchProfile() -> Promise<StylistProfile> {
        guard
            let token = keychainService.fetchAccessToken()
        else {
            fatalError("Should be set")
        }

        return Promise { seal in
            api.request(endpoint: .get(token: token))
                .done { profile in
                    seal.fulfill(profile)
                }
                .catch { error in
                    if let error = error as? APIError,
                        let fetchError = FetchProfileError(rawValue: error.code) {
                        seal.reject(fetchError)
                    } else {
                        seal.reject(error)
                    }
                }
        }
    }

    func updateProfile(data: EditableUserProfile) -> Promise<Void> {
        guard
            let token = keychainService.fetchAccessToken()
        else {
            fatalError("Should be set")
        }
        return Promise { seal in
            api.request(endpoint: .update(profile: data, token: token)) { response in
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
