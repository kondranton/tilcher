import SnapKit
import YPImagePicker
import PromiseKit

struct Receipt: Codable {
    enum Status: String, Codable {
        case pending, approved, rejected
    }

    let id: Int
    let total: String
    let purchasedAt: Date
    let shop: Shop
    let receiptPhotos: [RemoteImage]
    var status: Status
}

struct NewReceipt {
    var money: Int?
    var date: Date?
    var shop: Shop?
    var photo: UIImage?
    var remoteImage: RemoteImage?
}

final class AddReceiptViewController: UITableViewController {
    private let receiptService = ReceiptService(keychainService: KeychainService())
    private let imageUploadService = ImageUploadService()
    private var imageUploadFinalizer: PMKFinalizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    private func setUp() {
        title = "Добавить чек"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundColor
        tableView.register(cellClass: InputFieldTableViewCell.self)
        tableView.register(cellClass: OtherInputTableViewCell.self)
        tableView.register(cellClass: ActionButtonTableViewCell.self)
        tableView.register(cellClass: AddBillPhotoTableViewCell.self)
        tableView.register(cellClass: BillPhotoTableViewCell.self)
    }

    var receipt = NewReceipt()
    var isSending = false {
        didSet {
            tableView.reloadData()
        }
    }

    var viewModel: [Field] {
        return [
            .money(receipt.money),
            .date(receipt.date),
            .shop(receipt.shop),
            .photo(receipt.photo),
            .action(
                enabled: receipt.money != nil && receipt.date != nil
                    && receipt.shop != nil && receipt.photo != nil && !isSending
            )
        ]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = viewModel[indexPath.row]
        switch field {
        case .money(let value):
            let cell: InputFieldTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(
                placeholder: "Сумма по чеку (руб)",
                value: value.flatMap(String.init) ?? "",
                keyboardType: .numberPad
            ) { [weak self] text in
                self?.receipt.money = Int(text)
                self?.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
            }
            return cell
        case .date(let date):
            let cell: OtherInputTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(
                with: OtherInputViewModel(
                    textRepresentationValue: date.flatMap(FormatterHelper.string(from:)),
                    placeholder: "Дата покупки",
                    hasChevron: true
                )
            )
            return cell
        case .shop(let shop):
            let cell: OtherInputTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(
                with: OtherInputViewModel(
                    textRepresentationValue: shop?.name,
                    placeholder: "Магазин",
                    hasChevron: true
                )
            )
            return cell
        case .photo(let image):
            if let image = image {
                let cell: BillPhotoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.setUp(with: image)
                return cell
            } else {
                let cell: AddBillPhotoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                return cell
            }
        case .action(let enabled):
            let cell: ActionButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(
                with: ActionButtonViewModel(title: "Готово", isEnabled: enabled)
            ) { [weak self] in
                self?.doneTap()
            }
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        let field = viewModel[indexPath.row]
        switch field {
        case .date:
            self.showDatePicker()
        case .photo:
            let picker = YPImagePicker()
            picker.didFinishPicking { [weak picker, self] items, _ in
                if let photo = items.singlePhoto {
                    self.set(image: photo.image)
                }
                picker?.dismiss(animated: true, completion: nil)
            }
            self.present(picker, animated: true, completion: nil)
        case .shop:
            self.openShops()
        default:
            break
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    private func showDatePicker() {
        let alert = UIAlertController(style: .actionSheet, title: "Выбрать дату")
        alert.addDatePicker(
            mode: .dateAndTime,
            date: receipt.date ?? Date(),
            minimumDate: Date().addingTimeInterval(-30_000_000),
            maximumDate: Date().addingTimeInterval(60 * 5)
        ) { [weak self] date in
            self?.receipt.date = date
            self?.tableView.reloadData()
        }
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }

    private func openShops() {
        let viewController = ShopsViewController()
        viewController.selectedShop = receipt.shop
        viewController.selectionCompletion = { [weak self] shop in
            self?.receipt.shop = shop
            self?.tableView.reloadData()
        }
        show(viewController, sender: nil)
    }

    private func set(image: UIImage) {
        receipt.photo = image
        tableView.reloadData()
        imageUploadFinalizer = imageUploadService.upload(image: image)
            .done { remoteImage in
                self.receipt.remoteImage = remoteImage
            }
            .catch { error in
                assertionFailure(error.localizedDescription)
            }
    }

    private func doneTap() {
        if let finalizer = imageUploadFinalizer {
            finalizer.finally {
                self.createReceipt()
            }
        } else {
            createReceipt()
        }
    }

    private func createReceipt() {
        isSending = true
        receiptService
            .create(receipt: receipt)
            .done {
                NotificationCenter.default.post(name: .receiptsChanged, object: nil)
                self.navigationController?.popViewController(animated: true)
            }
            .catch { error in
                assertionFailure(error.localizedDescription)
            }
            .finally {
                self.isSending = false
            }
    }

    enum Field {
        case money(Int?)
        case date(Date?)
        case shop(Shop?)
        case photo(UIImage?)
        case action(enabled: Bool)
    }
}
