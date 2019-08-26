import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    var profile: StylistProfile

    private let profileService: ProfileServiceProtocol

    private var underlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryColor
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.register(cellClass: ProfileHeaderTableViewCell.self)
        tableView.register(cellClass: ProfileItemTableViewCell.self)
        return tableView
    }()

    var items: [ProfileItemModel] {
        guard let statistics = profile.counts else {
            fatalError("Incomplete profile")
        }
        return [
            .header(
                ProfileHeaderItemModel(
                    money: profile.balance.cashback,
                    points: profile.balance.score,
                    name: profile.name,
                    imagePath: "" // profile.imagePath
                )
            ),
            .statistics(
                ProfileStatisticsItemModel(
                    itemType: .looks,
                    value: statistics.looks
                )
            ),
            .statistics(
                ProfileStatisticsItemModel(
                    itemType: .publications,
                    value: statistics.instagramPosts
                )
            ),
            .statistics(
                ProfileStatisticsItemModel(
                    itemType: .shops,
                    value: statistics.shops
                )
            ),
            .statistics(
                ProfileStatisticsItemModel(
                    itemType: .clients,
                    value: statistics.clients
                )
            ),
            .statistics(
                ProfileStatisticsItemModel(
                    itemType: .usersInvited,
                    value: statistics.invitedUsers
                )
            )
        ]
    }

    init(profileService: ProfileServiceProtocol) {
        self.profile = StylistProfile(
            id: 2,
            phone: "",
            name: "Татьяна Ильчишина",
            type: .stylist,
            reviewStatus: .approved,
            instagramUsername: "tanya_tilcha",
            counts: StylistProfile.Statistics(
                looks: 25,
                instagramPosts: 48,
                shops: 20,
                clients: 3,
                invitedUsers: 1200
            ),
            balance: StylistProfile.Balance(score: 1200, cashback: 1302)//,
//            imagePath: "https://www.vsh.is/images/carousel/liekarusel/liekaruselsss.jpg"
        )
        self.profileService = profileService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .backgroundColor

        [
            underlayView,
            tableView
        ]
        .forEach(view.addSubview)

        underlayView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButton(
            UIBarButtonItem(
                image: UIImage(named: "settings"),
                style: .plain,
                target: self,
                action: #selector(openSettings)
            ),
            animated: false
        )
        fetchProfile()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchProfile),
            name: .profileChanged,
            object: nil
        )
    }

    @objc
    private func fetchProfile() {
        profileService.fetchProfile()
        .done { profile in
            self.profile = profile
            self.tableView.reloadData()
        }
        .catch { error in
            assertionFailure(error.localizedDescription)
        }
    }

    func configure(with profile: StylistProfile) {
    }

    @objc
    func openSettings() {
        let profileEditViewController = ProfileEditViewController(
            profile: NewUserProfile(profile: profile),
            profileService: profileService
        )
        let navigationController = UINavigationController()
        navigationController.viewControllers = [profileEditViewController]
        present(navigationController, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        switch item {
        case .header(let profile):
            let cell: ProfileHeaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: profile)
            return cell
        case .statistics(let statistics):
            let cell: ProfileItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: statistics)
            return cell
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

