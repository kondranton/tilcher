import UIKit
import SnapKit

class HeaderLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setUp() {
        font = .systemFont(ofSize: 17, weight: .bold)
        textColor = .subtitleColor
        backgroundColor = .backgroundColor
    }

    var topInset: CGFloat = 0
    var bottomInset: CGFloat = 0
    var leftInset: CGFloat = 16.0
    var rightInset: CGFloat = 0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + leftInset + rightInset,
            height: size.height + topInset + bottomInset
        )
    }
}

final class ShopsViewController: UITableViewController {
    private let shopAssignmentsService = ShopsService(keychainService: KeychainService())

    var assignments = [ListPageResponse<ShopAssignment>]()
    var sections = [(type: Section, content: [ShopAssignment])]()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetshShopAssignments()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.isEmpty ? 1 : sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.isEmpty ? 1 : sections[section].content.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sections.isEmpty {
            let cell: BannerTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: "Пока магазинов нет. Они появятся в течение 15 минут.")
            return cell
        } else {
            let section = sections[indexPath.section]
            let cell: ShopTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: ShopItemViewModel(shopReview: section.content[indexPath.row]))
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if sections.isEmpty {
            return nil
        } else {
            let title = sections[section].type.title
            let label = HeaderLabel()
            label.text = title
            return label
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let assignment = sections[indexPath.section].content[indexPath.row]
        open(assignedShop: assignment)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections.isEmpty {
            return UITableView.automaticDimension
        } else {
            return 86
        }
    }

    private func setUp() {
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = [.top, .bottom]
        tableView.refreshControl = SpinnerRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(fetshShopAssignments), for: .valueChanged)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundColor
        tableView.register(cellClass: ShopTableViewCell.self)
        tableView.register(cellClass: BannerTableViewCell.self)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetshShopAssignments),
            name: .assignmentsChanged,
            object: nil
        )
    }

    @objc
    private func fetshShopAssignments() {
        shopAssignmentsService
            .getShopAssignments()
            .done { assignments in
                self.got(assignments: assignments)
            }
            .catch { error in
                assertionFailure(error.localizedDescription)
            }
            .finally {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
    }

    private func got(assignments: ListPageResponse<ShopAssignment>) {
        self.assignments = [assignments]
        self.sections = makeSections()
    }

    private func makeSections() -> [(type: Section, content: [ShopAssignment])] {
        var sections = [(type:Section, content: [ShopAssignment])] ()

        let assignments = self.assignments.flatMap { $0.results }
        let completed = assignments.filter {
            $0.assignment.status == .completedApproved || $0.assignment.status == .completedRejected
        }
        let assigned = assignments.filter { $0.assignment.status == .assigned }
        let accepted = assignments.filter { $0.assignment.status == .assignmentAccepted }
        let pending = assignments.filter { $0.assignment.status == .completedPending }

        if !accepted.isEmpty {
            sections.append((type: .accepted, content: accepted))
        }

        if !assigned.isEmpty {
            sections.append((type: .assigned, content: assigned))
        }

        if !pending.isEmpty {
            sections.append((type: .pending, content: pending))
        }

        if !completed.isEmpty {
            sections.append((type: .completed, content: completed))
        }

        return sections
    }

    private func open(assignedShop: ShopAssignment) {
        let shopViewController = ShopViewController(shopReview: assignedShop)
        show(shopViewController, sender: nil)
        AnalyticsEvents.Shops.selectedShop(
            name: assignedShop.shop.name,
            score: assignedShop.assignment.points
        ).send()
    }

    enum Section {
        case pending, accepted, assigned, completed

        var title: String {
            switch self {
            case .pending:
                return "Проверяются"
            case .accepted:
                return "Делаю обзоры"
            case .assigned:
                return "Новые заказы"
            case .completed:
                return "Завершены"
            }
        }
    }
}
