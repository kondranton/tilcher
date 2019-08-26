import UIKit

final class MainTabBarController: UITabBarController {
    let items = [
        UITabBarItem(
            title: "Магазины",
            image: UIImage(named: "shops"),
            selectedImage: nil
        ),
        UITabBarItem(
            title: "Профиль",
            image: UIImage(named: "profile"),
            selectedImage: nil
        )
    ]

    private let profileService: ProfileServiceProtocol

    private lazy var controllers = [
        ShopsViewController(),
        ProfileViewController(
            profileService: profileService
        )
    ]

    init(
        profileService: ProfileServiceProtocol
    ) {
        self.profileService = profileService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers(getViewControllers(), animated: false)
        configureTabBar()
    }

    private func configureTabBar() {
        tabBar.barTintColor = .white
        tabBar.tintColor = .black
    }

    private func getViewControllers() -> [UIViewController] {
        return zip(items, controllers).map { item, controller in
            controller.title = item.title
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.tabBarItem = item
            if #available(iOS 11.0, *) {
                navigationController.navigationBar.prefersLargeTitles = true
            }
            return navigationController
        }
    }
}
