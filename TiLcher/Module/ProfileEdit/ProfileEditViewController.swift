import SnapKit
import YPImagePicker
import PromiseKit

final class ProfileEditViewController: UITableViewController {
    private let authService = AuthorizationService()
    private let imageUploadService = ImageUploadService()
    private let profileService: ProfileServiceProtocol
    private var profile: EditableUserProfile

    private var imageUploadFinalizer: PMKFinalizer?

    private enum Field {
        case photo(String)
        case name(String)
        case instagram(String)
        case button(String)
    }

    private var fields: [Field] {
        return [
            .photo(profile.image?.url ?? ""),
            .name(profile.name),
            .instagram(profile.instagramUsername),
            .button("Выйти")
        ]
    }

    init(
        profile: EditableUserProfile,
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
        AnalyticsEvents.ProfileEdit.open.send()
        title = "Редактировать"
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

        setUpTableView()
    }

    @objc
    private func cancelTap() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc
    private func doneTap() {
        if let finalizer = imageUploadFinalizer {
            finalizer.finally {
                self.updateProfile()
            }
        } else {
            updateProfile()
        }
    }

    private func updateProfile() {
        profileService.updateProfile(data: profile)
            .done(on: .main) {
                NotificationCenter.default.post(name: .profileChanged, object: nil)
                self.navigationController?.dismiss(animated: true, completion: nil)
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

    private func set(image: UIImage) {
        imageUploadFinalizer = imageUploadService.upload(image: image)
            .done { remoteImage in
                self.profile.image = remoteImage
            }
            .catch { error in
                assertionFailure(error.localizedDescription)
            }
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
                picker.didFinishPicking { [weak picker, self] items, _ in
                    if let photo = items.singlePhoto {
                        cell.photoView.imageView.image = photo.image
                        self.set(image: photo.image)
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
            cell.setUp(with: ActionButtonViewModel(title: name, isEnabled: true)) { [weak self] in
                AnalyticsEvents.ProfileEdit.logOut.send()
                self?.authService.logout()
            }
            return cell
        }
    }
}


