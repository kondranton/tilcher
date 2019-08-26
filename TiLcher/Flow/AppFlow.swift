import UIKit

final class AppFlow {
    private let profileService: ProfileServiceProtocol
    private let keychainService: KeychainServiceProtocol
    private let window: UIWindow

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    init(
        window: UIWindow,
        keychainService: KeychainServiceProtocol,
        profileService: ProfileServiceProtocol
    ) {
        self.window = window
        self.keychainService = keychainService
        self.profileService = profileService
    }

    func start() {
        if keychainService.hasToken() {
            authorizedStart()
        } else {
            unauthorizedStart()
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(authChanged),
            name: .authChanged,
            object: nil
        )
    }

    private func makeLaunchScreenController() -> UIViewController {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("Should be available")
        }
        return viewController
    }

    private func makeMainController() -> UIViewController {
        let viewController = MainTabBarController(profileService: profileService)
        return viewController
    }

    private func makeAuthController() -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.view.backgroundColor = .backgroundColor
        navigationController.viewControllers = [AuthorizationViewController()]
        return navigationController
    }

    private func authorizedStart() {
        start(with: makeLaunchScreenController())

        profileService.fetchProfile()
            .done { profile in
                if profile.type == .consumer {
                    self.start(with: ProfileReviewViewController(userType: .consumer))
                } else {
                    switch profile.reviewStatus {
                    case .pending:
                        self.start(with: ProfileReviewViewController(userType: .stylist))
                    case .approved:
                        self.start(with: self.makeMainController())
                    case .rejected:
                        self.start(with: self.makeAuthController())
                    }
                }
            }
            .catch { error in
                assertionFailure(error.localizedDescription)
            }
    }

    private func start(with viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

    private func unauthorizedStart() {
        window.rootViewController = makeAuthController()
        window.makeKeyAndVisible()
    }

    @objc
    func authChanged() {
        if keychainService.hasToken() {
            authorizedStart()
        } else {
            unauthorizedStart()
        }
    }
}
