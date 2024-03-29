import SnapKit

final class ShopsViewController: UITableViewController {
    let shopService = ShopsService(keychainService: KeychainService())
    var shops = [Shop]()
    var selectedShop: Shop?
    var selectionCompletion: ((Shop) -> Void)?

    var viewModel: [ShopViewModel] {
        return shops.map { shop in
            ShopViewModel(
                name: shop.name,
                imagePath: shop.image?.url,
                isSelected: selectedShop.flatMap { $0 == shop } ?? false
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetchShops()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectableShopTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setUp(with: viewModel[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let shop = shops[indexPath.row]
        selectionCompletion?(shop)
        navigationController?.popViewController(animated: true)
    }

    private func setUp() {
        title = "Выбрать магазин"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundColor
        tableView.register(cellClass: SelectableShopTableViewCell.self)
    }

    private func fetchShops() {
        shopService.get()
            .done { shopList in
                self.shops = shopList.results
                self.tableView.reloadData()
            }
            .catch { error in
                assertionFailure(error.localizedDescription)
            }
    }
}
