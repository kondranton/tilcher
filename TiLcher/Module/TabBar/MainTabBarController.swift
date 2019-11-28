import UIKit

final class MainTabBarController: UITabBarController {
    let items = [
        UITabBarItem(
            title: "Рейтинг",
            image: UIImage(named: "rating"),
            selectedImage: nil
        ),
        UITabBarItem(
            title: "Магазины",
            image: UIImage(named: "shops"),
            selectedImage: nil
        ),
        UITabBarItem(
            title: "Чеки",
            image: UIImage(named: "bills"),
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
        RatingViewController(),
        ShopAssignmentsViewController(),
        ReceiptsViewController(),
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

            if #available(iOS 13.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
                navBarAppearance.shadowImage = nil
                navBarAppearance.shadowColor = nil
                navBarAppearance.backgroundColor = .backgroundColor

                navigationController.navigationBar.standardAppearance = navBarAppearance
                navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
                navigationController.navigationBar.tintColor = .black
            }

            if #available(iOS 11.0, *) {
                navigationController.navigationBar.prefersLargeTitles = true
            }
            return navigationController
        }
    }
}
