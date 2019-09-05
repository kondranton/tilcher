import UIKit

struct ShopReviewResults {
    var looks: Int = 0
    var collages: Int = 0
    var stories: Int = 0
    var posts: Int = 0
    var review: String = ""
}

final class ShopCompleteViewController: UITableViewController {
    private let instagramService = InstagramService()
    private let shopService = ShopsService(keychainService: KeychainService())

    let assignment: ShopAssignment
    var shopReview = ShopReviewResults()

    private var viewModel: ShopAssignmentResultsViewModel {
        return ShopAssignmentResultsViewModel(
            counts: AssignmentResultsViewModel(
                looksChange: { self.shopReview.looks = $0 },
                collagesChange: { self.shopReview.collages = $0 },
                storiesChange: { self.shopReview.stories = $0 },
                postsChange: { self.shopReview.posts = $0 }
            ),
            report: AssignmentReportViewModel(
                textChanged: { self.shopReview.review = $0 }
            )
        )
    }

    init(assignment: ShopAssignment) {
        self.assignment = assignment
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
            cell.setUp(with: viewModel.counts)
            return cell
        case 1:
            let cell: ReviewTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case 2:
            let cell: ActionButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: "Отправить") { [weak self] in
                self?.send()
            }
            return cell
        default:
            fatalError("Not implemented")
        }
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func send() {
        AnalyticsEvents.ShopReview.sent.send()
        shopService
            .complete(assignment: assignment, shopReviewResult: shopReview)
            .done {
                self.navigationController?.popToRootViewController(animated: true)
            }
            .catch { error in
                assertionFailure(error.localizedDescription)
            }
    }
}
