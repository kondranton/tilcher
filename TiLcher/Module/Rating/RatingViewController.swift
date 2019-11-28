import SnapKit

final class RatingViewController: UITableViewController {
    private let minShopsCount = 5
    private let winningPlacesCount = 3

    private let ratingService = RatingService()
    private var competitionEndDates = [Date]()
    private var stylists = [RankedStylist]()
    private let fetchGroup = DispatchGroup()

    var rows = [Row]()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.fetchData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        switch row {
        case .prizeBanner(let days):
            let cell: PrizeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: days)
            return cell
        case .participant(let participant):
            let cell: RatingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: participant)
            return cell
        case .placeholder(let position):
            let cell: RatingPlaceholderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: position)
            return cell
        }
    }

    @objc
    private func fetchData() {
        fetchPrizeDate()
        fetchProfiles()

        fetchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else {
                return
            }

            self.refreshControl?.endRefreshing()
            self.rows = self.makeRows()
            self.tableView.reloadData()
        }
    }

    private func fetchPrizeDate() {
        self.fetchGroup.enter()
        self.ratingService.fetchOngoingContests().done { contests in
            self.competitionEndDates = contests.map { $0.endDate }
        }.catch { error in
            assertionFailure(error.localizedDescription)
        }.finally {
            self.fetchGroup.leave()
        }
    }

    private func fetchProfiles() {
        self.fetchGroup.enter()
        self.ratingService.fetchRating().done { response in
            self.stylists = response.results
            print(response)
        }.catch { error in
            assertionFailure(error.localizedDescription)
        }.finally {
            self.fetchGroup.leave()
        }
    }

    private func setUp() {
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = [.top, .bottom]
        self.tableView.refreshControl = SpinnerRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        self.tableView.separatorStyle = .none
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.backgroundColor = .backgroundColor
        self.tableView.register(cellClass: RatingTableViewCell.self)
        self.tableView.register(cellClass: RatingPlaceholderTableViewCell.self)
        self.tableView.register(cellClass: PrizeTableViewCell.self)
    }

    private func makeRows() -> [Row] {
        let dateRows: [Row] = competitionEndDates.compactMap { date in
            let days = date.days(from: Date())
            if days < 0 {
                return nil
            } else {
                return .prizeBanner(days)
            }
        }

        func participant(stylist: RankedStylist, index: Int) -> Row {
            return .participant(
                ParticipantViewModel(
                    position: "\(index + 1)",
                    name: stylist.name,
                    points: stylist.pointsData?.totalPoints ?? 0,
                    looks: "\(stylist.pointsData?.looksCount ?? 0)",
                    publications: "\(stylist.pointsData?.publicationsCount ?? 0)",
                    shops: "\(stylist.pointsData?.shopsCount ?? 0)",
                    imagePath: stylist.profilePhoto?.url
                )
            )
        }

        let winners = self.stylists.lazy
            .prefix(while: { ($0.pointsData?.shopsPoints ?? 0) >= self.minShopsCount })
            .prefix(self.winningPlacesCount)
            .enumerated()
            .map { item in
                participant(
                    stylist: item.element,
                    index: item.offset
                )
            }

        let placeholdersCount = self.winningPlacesCount - winners.count
        let placeholdersIndexRange = winners.count..<(winners.count + placeholdersCount)
        let placeholders: [Row] = placeholdersIndexRange.map { .placeholder("\($0 + 1)") }

        let losers: [Row] = self.stylists
            .suffix(from: winners.count)
            .enumerated()
            .map { item in
                participant(
                    stylist: item.element,
                    index: winners.count + placeholdersCount + item.offset
                )
            }

        return winners + placeholders + losers
    }

    enum Row {
        case prizeBanner(Int)
        case placeholder(String)
        case participant(ParticipantViewModel)
    }
}
