import SnapKit

final class BillsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    @objc
    func addTap() {
        let viewController = AddBillViewController()
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
        tableView.register(cellClass: BillTableViewCell.self)
        tableView.register(cellClass: BannerTableViewCell.self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BillTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
}
