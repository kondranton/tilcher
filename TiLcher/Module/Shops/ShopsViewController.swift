import UIKit
import SnapKit

final class ShopsViewController: UITableViewController {
    var shops = [ShopItemViewModel](
        repeating: .init(shopReview: .mock),
        count: 10
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundColor
        tableView.register(cellClass: ShopTableViewCell.self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShopTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setUp(with: shops[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openTemp()
    }

    private func openTemp() {
        let shopViewController = ShopViewController(shopReview: .mock)
        show(shopViewController, sender: nil)
    }

    private func open(assignedShop: ShopAssignment) {
        let shopViewController = ShopViewController(shopReview: assignedShop)
        show(shopViewController, sender: nil)
        AnalyticsEvents.Shops.selectedShop(
            name: assignedShop.shop.name,
            score: assignedShop.rewards.pointsForLook
        ).send()
    }
}
