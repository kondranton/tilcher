import SnapKit

final class ReceiptsViewController: UITableViewController {
    private let receiptService = ReceiptService(keychainService: KeychainService())

    var receipts = [ListPageResponse<Receipt>]()
    var sections = [(type: Section, content: [Receipt])]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetchReceipts()
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
            cell.setUp(with: "Пока чеков нет. Добавь первый!")
            return cell
        } else {
            let model = ReceiptViewModel(
                receipt: sections[indexPath.section].content[indexPath.row]
            )
            let cell: ReceiptTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: model)
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

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    @objc
    private func addTap() {
        let viewController = AddReceiptViewController()
        show(viewController, sender: nil)
    }

    private func setUp() {
        title = "Чеки"

        navigationItem.setRightBarButton(
            UIBarButtonItem(
                image: UIImage(named: "add"),
                style: .plain,
                target: self,
                action: #selector(addTap)
            ),
            animated: false
        )

        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = [.top, .bottom]
        tableView.refreshControl = SpinnerRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(fetchReceipts), for: .valueChanged)
        tableView.separatorStyle = .none
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundColor
        tableView.register(cellClass: ReceiptTableViewCell.self)
        tableView.register(cellClass: BannerTableViewCell.self)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchReceipts),
            name: .receiptsChanged,
            object: nil
        )
    }

    @objc
    private func fetchReceipts() {
        receiptService
            .getReceipts()
            .done { receipts in
                self.receipts = [receipts]
                self.sections = self.makeSections()
            }
            .catch { error in
                assertionFailure(error.localizedDescription)
            }
            .finally {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
    }

    private func makeSections() -> [(type: Section, content: [Receipt])] {
        guard let receipts = receipts.first?.results else {
            assertionFailure("Should be called when has values")
            return []
        }

        var sections = [(type:Section, content: [Receipt])]()

        let pending = receipts.filter { $0.status == .pending }
        let approved = receipts.filter { $0.status == .approved }
        let rejected = receipts.filter { $0.status == .rejected }

        if !approved.isEmpty {
            sections.append((type: .approved, content: approved))
        }

        if !pending.isEmpty {
            sections.append((type: .pending, content: pending))
        }

        if !rejected.isEmpty {
            sections.append((type: .rejected, content: rejected))
        }

        return sections
    }

    enum Section {
        case pending, approved, rejected

        var title: String {
            switch self {
            case .pending:
                return "Проверяются"
            case .approved:
                return "Одобрены"
            case .rejected:
                return "Отклонены"
            }
        }
    }
}
