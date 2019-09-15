import SnapKit

struct ReceiptViewModel {
    let price: String
    let shop: String
    let date: String
    let commissionAbsolute: String
    let commissionRelative: String
    let photoURL: URL?
}

extension ReceiptViewModel {
    init(receipt: Receipt) {
        price = "\(receipt.total)р"
        shop = receipt.shop.name
        date = FormatterHelper.string(from: receipt.purchasedAt)
        let total = Double(receipt.total) ?? 1
        let comission = Double(receipt.shop.defaultCashback) / 100
        commissionAbsolute = "\(Int(total * comission))"
        commissionRelative = "кэшбек \(receipt.shop.defaultCashback)%"
        photoURL = receipt.receiptPhotos.first.flatMap { URL(string: $0.url) }
    }
}

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
