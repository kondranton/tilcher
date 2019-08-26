import UIKit
import SnapKit

final class ShopViewController: UIViewController, SFViewControllerPresentable {
    private let instagramService = InstagramService()

    var shopReview: ShopAssignment

    enum ShopReviewField {
        case info(Shop)
        case rewards(ShopAssignment.Rewards)
        case places([Shop.Place])
        case actionButton(ShopAssignment.Stage)
    }

    lazy var fields: [ShopReviewField] = [
        .info(shopReview.shop),
        .rewards(shopReview.rewards),
        .places(shopReview.shop.places),
        .actionButton(shopReview.stage)
    ]

    lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.register(cellClass: ShopReviewInfoTableViewCell.self)
        tableView.register(cellClass: ShopRewardsTableViewCell.self)
        tableView.register(cellClass: ShopPlacesTableViewCell.self)
        tableView.register(cellClass: ActionButtonTableViewCell.self)

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    init(shopReview: ShopAssignment) {
        self.shopReview = shopReview
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundColor
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = shopReview.shop.name
    }

    func openReport() {
        let reportViewController = ShopReviewResultsViewController()
        show(reportViewController, sender: nil)
    }
}

extension ShopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = fields[indexPath.row]

        switch field {
        case let .info(shop):
            let cell: ShopReviewInfoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: shop) { [weak self] in
                guard let self = self else {
                    return
                }
                self.instagramService.openAccount(
                    named: shop.instagram,
                    in: self
                )
            }
            return cell
        case let .rewards(rewards):
            let cell: ShopRewardsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: rewards)
            return cell
        case let .places(places):
            let cell: ShopPlacesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: places)
            return cell
        case let .actionButton(stage):
            let cell: ActionButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: stage.actionTitle) { [weak self] in
                self?.openReport()
            }
            return cell
        }
    }
}

extension ShopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

