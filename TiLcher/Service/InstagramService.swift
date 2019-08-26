import UIKit

final class InstagramService {
    func openAccount(named accountName: String, in viewController: SFViewControllerPresentable) {
        guard
            let url = URL(string: "instagram://user?username=\(accountName)")
        else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            guard
                let url = URL(string: "https://instagram.com/\(accountName)")
            else {
                return
            }
            viewController.open(url: url)
        }
    }
}
