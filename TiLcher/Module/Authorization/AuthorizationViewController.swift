import UIKit
import SnapKit

final class AuthorizationViewController: UIViewController, SFViewControllerPresentable {
    enum State: Int {
        case requestCode, verifyCode, name, userType, instagram
    }

    var state = State.requestCode

    private let authService = AuthorizationService()
    private var newUser = NewUserProfile()
    private var verificationPackage: AuthVerificationPackage?

    var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var collectionView: UICollectionView = {
        let layout = PageCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.invalidateLayout()
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.register(cellClass: PageCollectionViewCell.self)
        view.alwaysBounceHorizontal = true
        view.isScrollEnabled = false
        view.isPagingEnabled = true

        return view
    }()

    lazy var smsViewController: CodeVerificationViewController = {
        CodeVerificationViewController(
            onEditingChange: { [weak self] in
                self?.animateFormView(isEditing: $0)
            },
            onNext: { [weak self] result in
                switch result {
                case .registration:
                    self?.next()
                case .login:
                    NotificationCenter.default.post(name: .authChanged, object: nil)
                }
            },
            onBack: { [weak self] in self?.previous() },
            onError: { [weak  self] message in
                self?.show(errorMessage: message)
            }
        )
    }()

    lazy var controllers: [UIViewController] = [
        CodeRequestViewController(
            onEditingChange: { [weak self] in
                self?.animateFormView(isEditing: $0)
            },
            onBecomeStylistTap: { [weak self] in self?.open(url: $0) },
            sentCode: { [weak self] verificationPackage in
                guard let self = self else {
                    return
                }
                self.verificationPackage = verificationPackage
                self.smsViewController.verificationPackage = verificationPackage
                self.next()
            },
            onError: { [weak self] message in
                self?.show(errorMessage: message)
            }
        ),
        smsViewController,
        NameAuthViewController(
            onEditingChange: { [weak self] in
                self?.animateFormView(isEditing: $0)
            },
            onNext: { [weak self] name in
                self?.newUser.name = name
                self?.next()
            }
        ),
        UserTypeViewController(
            onBack: { [weak self] in self?.previous() },
            onNext: { [weak self] userType in
                self?.newUser.type = userType
                self?.next()
            }
        ),
        InstagramFormViewController(
            onEditingChange: { [weak self] in
                self?.animateFormView(isEditing: $0)
            },
            onBack: { [weak self] in self?.previous() },
            onNext: { [weak self] instagram in
                self?.newUser.instagramUsername = instagram
                self?.next()
            }
        )
    ]

    func animateFormView(isEditing: Bool) {
        UIView.animate(withDuration: 0.5) {
            if isEditing {
                self.logoImageView.transform = .init(
                    translationX: 0,
                    y: -UIScreen.main.bounds.height / 2
                )
                self.collectionView.transform = .init(
                    translationX: 0,
                    y: -self.collectionView.frame.minY + 40
                )
            } else {
                self.logoImageView.transform = .identity
                self.collectionView.transform = .identity
            }
        }
    }

    private func next() {
        switch state {
        case .requestCode:
            collectionView.scrollToItem(
                at: IndexPath(item: 1, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
            state = .verifyCode
        case .verifyCode:
            collectionView.scrollToItem(
                at: IndexPath(item: 2, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
            state = .name
        case .name:
            collectionView.scrollToItem(
                at: IndexPath(item: 3, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
            view.endEditing(true)
            AnalyticsEvents.Auth.nextTapped(success: true, screen: .name).send()
            state = .userType
        case .userType:
            collectionView.scrollToItem(
                at: IndexPath(item: 4, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
            AnalyticsEvents.Auth.nextTapped(success: true, screen: .userType).send()
            state = .instagram
        case .instagram:
            finishAuth()
        }
    }

    private func previous() {
        switch state {
        case .verifyCode:
            collectionView.scrollToItem(
                at: IndexPath(item: 0, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
            state = .requestCode
        case .userType:
            collectionView.scrollToItem(
                at: IndexPath(item: 2, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
            state = .name
        case .instagram:
            collectionView.scrollToItem(
                at: IndexPath(item: 3, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
            state = .userType
        default:
            fatalError("Not implemented")
        }
    }

    override func loadView() {
        let view = UIView()

        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "auth_background")
        backgroundImageView.contentMode = .scaleAspectFill

        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        [
            logoImageView,
            collectionView
        ]
        .forEach(view.addSubview)

        let groupGuide = UILayoutGuide()
        view.addLayoutGuide(groupGuide)

        logoImageView.snp.makeConstraints { make in
            make.topMargin.equalTo(groupGuide.snp.topMargin)
            make.leading.equalTo(groupGuide.snp.leading).offset(20)
            make.trailing.equalTo(groupGuide.snp.trailing).offset(-20)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(400)
            make.bottom.equalTo(groupGuide.snp.bottom)
        }

        groupGuide.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsEvents.Auth.opened.send()
    }

    private func show(errorMessage: String) {
        let alert = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    private func finishAuth() {
        guard let verificationPackage = verificationPackage else {
            assertionFailure("Should be set")
            return
        }

        authService.signup(
            profile: newUser,
            verificationPackage: verificationPackage
        )
        .done(on: .main) { _ in
            AnalyticsEvents.Auth.nextTapped(success: true, screen: .instagram).send()
            NotificationCenter.default.post(name: .authChanged, object: nil)
        }
        .catch { error in
            AnalyticsEvents.Auth.nextTapped(success: false, screen: .instagram).send()
            self.show(errorMessage: error.localizedDescription)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension AuthorizationViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension AuthorizationViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return controllers.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let controller = controllers[indexPath.row]
        controller.willMove(toParent: self)
        addChild(controller)
        let cell: PageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.layout(view: controller.view)
        controller.didMove(toParent: self)
        return cell
    }
}
