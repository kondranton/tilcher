import UIKit
import SnapKit

final class ShopViewController: UIViewController, SFViewControllerPresentable {
    private let instagramService = InstagramService()
    private let shopsService = ShopsService(keychainService: KeychainService())

    var shopReview: ShopAssignment

    enum ShopReviewField {
        case info(Shop)
        case rewards(ShopAssignment.Rewards)
        case places([Shop.Place])
        case banner(String)
        case actionButton(ShopAssignment.Stage)
    }

    var fields: [ShopReviewField] {
        if shopReview.assignment.status == .completedPending {
            return [
                .banner("Отправленная тобой статистика по обзору будет проверена командой Tilcher в течение суток.")
            ]
        }

        if shopReview.assignment.status == .completedApproved {
            return [
                .banner("Твой обзор успешно завершен! Начисленные баллы можно видеть в профиле.")
            ]
        }

        if shopReview.assignment.status == .completedRejected {
            return [
                .banner("Отправленная тобой статистика по обзору была отклонена из-за неточностей")
            ]
        }

        switch shopReview.shop.type {
        case .online:
            return [
                .info(shopReview.shop),
                .rewards(
                    ShopAssignment.Rewards(
                        pointsForLook: shopReview.assignment.points,
                        comission: shopReview.assignment.cashback
                    )
                ),
                // swiftlint:disable line_length
                .banner("Это онлайн магазинин, его посещать не надо. Переходи в Инстаграм магазина, выбирай фото, дополняй луки или делай интересные подборки/коллажи в формате своего контента 😉"),
                // swiftlint:enable line_length
                .actionButton(shopReview.assignment.status)
            ]
        case .offline:
            return [
                .info(shopReview.shop),
                .rewards(
                    ShopAssignment.Rewards(
                        pointsForLook: shopReview.assignment.points,
                        comission: shopReview.assignment.cashback
                    )
                ),
                .places(shopReview.shop.locations),
                .actionButton(shopReview.assignment.status)
            ]
        }
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.register(cellClass: ShopReviewInfoTableViewCell.self)
        tableView.register(cellClass: ShopRewardsTableViewCell.self)
        tableView.register(cellClass: ShopPlacesTableViewCell.self)
        tableView.register(cellClass: BannerTableViewCell.self)
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

    func actionFired() {
        switch shopReview.assignment.status {
        case .assigned:
            accept()
            AnalyticsEvents.Shop.acceptedTap.send()
        case .assignmentAccepted:
            AnalyticsEvents.Shop.finishedTap.send()
            openReport()
        case .completedApproved:
            break
        case .completedPending:
            break
        case .completedRejected:
            break
        }
    }

    func accept() {
        shopsService.accept(assignment: shopReview)
            .done {
                self.shopReview.assignment.status = .assignmentAccepted
                self.tableView.reloadData()
                NotificationCenter.default.post(name: .assignmentsChanged, object: nil)
            }
            .catch { error in
                assertionFailure(error.localizedDescription)
            }
    }

    func openReport() {
        let reportViewController = ShopCompleteViewController(assignment: self.shopReview)
        show(reportViewController, sender: nil)
    }
}

extension ShopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
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
                    named: shop.instagramUsername,
                    in: self
                )
                AnalyticsEvents.Shop.instagramTap.send()
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
        case let .banner(text):
            let cell: BannerTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: text)
            return cell
        case let .actionButton(stage):
            let cell: ActionButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: stage.actionTitle) { [weak self] in
                self?.actionFired()
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

