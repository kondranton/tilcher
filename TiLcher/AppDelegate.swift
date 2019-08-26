import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var flow: AppFlow?

    //swiftlint:disable discouraged_optional_collection
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setUpAppearence()
        setUpServices()
        setUpFlow()

        flow?.start()

        return true
    }
    //swiftlint:enable discouraged_optional_collection

    func setUpServices() {
        // Google Maps
        GMSServices.provideAPIKey("AIzaSyA5qfzjCwFwayViIAs2aiJ6m3VSOQbWqiM")
        AnalyticsService().setupAnalyticsAndStartSession()
    }

    func setUpFlow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let keychainService = KeychainService()
        let flow = AppFlow(
            window: window,
            keychainService: keychainService,
            profileService: ProfileService(
                keychainService: keychainService,
                persistanceService: RealmPersistenceService.shared
            )
        )
        self.window = window
        self.flow = flow
    }
}

extension AppDelegate {
    fileprivate func setUpAppearence() {
        window?.tintColor = .backgroundColor
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = UIColor.backgroundColor
        UINavigationBar.appearance().barTintColor = UIColor.backgroundColor
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [
                .foregroundColor: UIColor.black
            ]
        } else {
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        }
    }
}
