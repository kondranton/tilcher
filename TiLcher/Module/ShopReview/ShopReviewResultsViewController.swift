import UIKit

struct ShopReviewResults {
    var looks: Int = 0
    var collages: Int = 0
    var stories: Int = 0
    var posts: Int = 0
    var review: String = ""
}

final class ShopReviewResultsViewController: UITableViewController {
    private let instagramService = InstagramService()

    var shopReview = ShopReviewResults()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Результаты"

        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundColor

        tableView.register(cellClass: ResultsTableViewCell.self)
        tableView.register(cellClass: ReviewTableViewCell.self)
        tableView.register(cellClass: ActionButtonTableViewCell.self)

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: ResultsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case 1:
            let cell: ReviewTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case 2:
            let cell: ActionButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: "Отправить") { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            return cell
        default:
            fatalError("Not implemented")
        }
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
