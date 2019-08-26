import SnapKit

final class ProfileReviewViewController: UIViewController {
    enum User {
        case stylist, consumer

        var message: String {
            switch self {
            //swiftlint:disable line_length
            case .stylist:
                return """
                Привет!
                Сейчас твой профиль проходит ревью команды стилистов TiLcher. Если мы не свяжемся с тобой в следующий рабочий день или ты хочешь что-то уточнить, пожалуйста, нажми кнопку внизу 😉
                """
            case .consumer:
                return """
                Привет!

                Пока TiLcher доступен только для стилистов. Но скоро мы предоставим возможность и шопоголикам пользоваться нашим сервисом. Если хочешь, чтобы мы прислали тебе смс, когда запустимся - нажми кнопку внизу 😉
                """
            //swiftlint:enable line_length
            }
        }

        var buttonText: String {
            switch self {
            case .consumer:
                return "Оповестить меня по смс!"
            case .stylist:
                return "Позвонить"
            }
        }
    }

    private let authorizationService = AuthorizationService()
    private let userType: User

    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        return imageView
    }()


    private var bannerView: BannerView = {
        let view = BannerView()
        return view
    }()

    private lazy var button: UIButton = {
        let button = StyledButtons.action()
        button.setAttributedTitle(
            NSAttributedString(
                string: userType.buttonText,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                    .foregroundColor: UIColor.secondaryColor
                ]
            ),
            for: .normal
        )
        return button
    }()

    private var logoutButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "Выйти",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                    .foregroundColor: UIColor.secondaryColor
                ]
            ),
            for: .normal
        )
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        return button
    }()

    init(userType: User) {
        self.userType = userType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .backgroundColor

        let layoutGuide = UILayoutGuide()
        view.addLayoutGuide(layoutGuide)
        layoutGuide.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        [
            logoImageView,
            bannerView,
            button,
            logoutButton
        ]
        .forEach(view.addSubview)

        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(layoutGuide)
            make.leading.equalTo(layoutGuide).offset(20)
            make.trailing.equalTo(layoutGuide).offset(-20)
            make.height.equalTo(logoImageView.snp.width).multipliedBy(0.29)
        }

        bannerView.snp.makeConstraints { make in
            make.leading.equalTo(layoutGuide).offset(16)
            make.trailing.equalTo(layoutGuide).offset(-16)
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
        }

        button.snp.makeConstraints { make in
            make.leading.equalTo(layoutGuide).offset(40)
            make.trailing.equalTo(layoutGuide).offset(-40)
            make.top.equalTo(bannerView.snp.bottom).offset(24)
            make.height.equalTo(48)
        }

        logoutButton.snp.makeConstraints { make in
            make.leading.equalTo(layoutGuide).offset(40)
            make.trailing.equalTo(layoutGuide).offset(-40)
            make.top.equalTo(button.snp.bottom).offset(20)
            make.bottom.equalTo(layoutGuide)
        }

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.text = userType.message
    }

    @objc
    private func logOut() {
        authorizationService.logout()
    }
}
