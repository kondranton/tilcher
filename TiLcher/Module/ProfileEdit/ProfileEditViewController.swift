import SnapKit
import YPImagePicker

final class ProfileEditViewController: UITableViewController {
    private let authService = AuthorizationService()
    private let profileService: ProfileServiceProtocol
    private var profile: NewUserProfile

    private enum Field {
        case photo(URL)
        case name(String)
        case instagram(String)
        case button(String)
    }

    private var fields: [Field] {
        return [
            //swiftlint:disable force_unwrapping
            .photo(URL(string: "https://pp.userapi.com/c630330/v630330771/8f99/4vYc79boVEI.jpg?ava=1")!),
            .name(profile.name),
            .instagram(profile.instagramUsername),
            .button("Выйти")
        ]
    }

    init(
        profile: NewUserProfile,
        profileService: ProfileServiceProtocol
    ) {
        self.profile = profile
        self.profileService = profileService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Редактировать"
        setUpTableView()

        navigationItem.setLeftBarButton(
            UIBarButtonItem(
                title: "Отменить",
                style: .plain,
                target: self,
                action: #selector(cancelTap)
            ),
            animated: false
        )
        navigationItem.setRightBarButton(
            UIBarButtonItem(
                title: "Готово",
                style: .done,
                target: self,
                action: #selector(doneTap)
            ),
            animated: false
        )
    }

    @objc
    private func cancelTap() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc
    private func doneTap() {
        navigationController?.dismiss(animated: true, completion: nil)
        profileService.updateProfile(data: profile)
            .done(on: .main) {
                NotificationCenter.default.post(name: .profileChanged, object: nil)
            }
            .catch { error in
                assertionFailure(error.localizedDescription)
            }
    }

    private func setUpTableView() {
        tableView.backgroundColor = .backgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(cellClass: EditPhotoTableViewCell.self)
        tableView.register(cellClass: InputFieldTableViewCell.self)
        tableView.register(cellClass: ActionButtonTableViewCell.self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = fields[indexPath.row]
        switch field {
        case .photo(let url):
            let cell: EditPhotoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: url) {
                let picker = YPImagePicker()
                picker.didFinishPicking { [weak picker] items, _ in
                    if let photo = items.singlePhoto {
                        cell.photoView.imageView.image = photo.image
                    }
                    picker?.dismiss(animated: true, completion: nil)
                }
                self.present(picker, animated: true, completion: nil)
            }
            return cell
        case .name(let text):
            let cell: InputFieldTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(
                placeholder: "Имя",
                value: text,
                keyboardType: .namePhonePad
            ) { [weak self] text in
                self?.profile.name = text
            }
            return cell
        case .instagram(let text):
            let cell: InputFieldTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(
                placeholder: "Instagram",
                value: text,
                keyboardType: .alphabet
            ) { [weak self] text in
                self?.profile.instagramUsername = text
            }
            return cell
        case .button(let name):
            let cell: ActionButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: name) { [weak self] in
                self?.authService.logout()
            }
            return cell
        }
    }
}


