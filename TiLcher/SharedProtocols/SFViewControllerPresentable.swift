import UIKit
import SafariServices

protocol SFViewControllerPresentable {
    func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Swift.Void)?
    )

    func open(url: URL?)
}

extension SFViewControllerPresentable {
    func open(url: URL?) {
        guard let url = url else {
            fatalError("Should show error")
        }

        present(
            SFSafariViewController(
                url: url
            ),
            animated: true,
            completion: nil
        )
    }
}
