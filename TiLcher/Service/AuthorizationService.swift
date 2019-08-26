import Foundation
import PromiseKit
import KeychainAccess

struct AuthVerificationPackage {
    let phone: String
    let verificationID: String
}

final class AuthorizationService {
    private let api = API<AuthorizationEndpoint>()
    private let keychainService = KeychainService()

    enum AuthResult {
        case login(StylistProfile)
        case registration
    }

    struct Auth: Codable {
        let token: String
        let expires: Int
    }

    struct AuthorizedResponse: Codable {
        let profile: StylistProfile
        let auth: Auth
    }

    func requestCode(to phone: String) -> Promise<AuthVerificationPackage> {
        return Promise { seal in
            let promise: Promise<Verifier> = api.request(endpoint: .requestCode(phone: phone))
            promise
                .done { verifier in
                    let package = AuthVerificationPackage(
                        phone: phone,
                        verificationID: verifier.verificationID
                    )

                    seal.fulfill(package)
                }
                .catch { error in
                    seal.reject(error)
                }
        }
    }

    func verify(code: String, verificationPackage: AuthVerificationPackage) -> Promise<AuthResult> {
        return Promise { seal in
            api.request(
                endpoint: .verify(code: code, verificationPackage: verificationPackage)
            ) { response in
                switch response.result {
                case .failure(let error):
                    seal.reject(error)
                case .success:
                    guard let statusCode = response.response?.statusCode else {
                        assertionFailure("Never")
                        return
                    }

                    switch statusCode {
                    case 202:
                        seal.fulfill(.registration)
                    case 200:
                        let decoder = JSONDecoder.common
                        guard let data = response.data else {
                            return
                        }
                        do {
                            let authorizedResponse = try decoder.decode(AuthorizedResponse.self, from: data)
                            self.keychainService.write(
                                token: authorizedResponse.auth.token,
                                phone: verificationPackage.phone
                            )
                            seal.fulfill(.login(authorizedResponse.profile))
                        } catch {
                            assertionFailure(error.localizedDescription)
                        }
                    default:
                        fatalError("Not implemented")
                    }
                }
            }
        }
    }

    func signup(profile: NewUserProfile, verificationPackage: AuthVerificationPackage) -> Promise<StylistProfile> {
        return Promise { seal in
            api.request(
                endpoint: .signup(user: profile, verificationPackage: verificationPackage)
            ) { response in
                switch response.result {
                case .failure(let error):
                    seal.reject(error)
                case .success:
                    guard let statusCode = response.response?.statusCode else {
                        assertionFailure("Never")
                        return
                    }

                    switch statusCode {
                    case 201:
                        let decoder = JSONDecoder.common
                        guard let data = response.data else {
                            return
                        }
                        do {
                            let authorizedResponse = try decoder.decode(AuthorizedResponse.self, from: data)
                            self.keychainService.write(
                                token: authorizedResponse.auth.token,
                                phone: verificationPackage.phone
                            )
                            seal.fulfill(authorizedResponse.profile)
                        } catch {
                            assertionFailure(error.localizedDescription)
                        }
                    default:
                        fatalError("Not implemented")
                    }
                }
            }
        }
    }

    func logout() {
        keychainService.clear()
        NotificationCenter.default.post(name: .authChanged, object: nil)
    }
}
