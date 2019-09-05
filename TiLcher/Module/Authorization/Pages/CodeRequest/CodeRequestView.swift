import SnapKit

final class CodeRequestView: AuthFormView {
    var onLoginTap: () -> Void
    var onBecomeStylistTap: () -> Void

    var isLoginEnabled: Bool {
        get {
            return loginButton.isEnabled
        }
        set {
            loginButton.isEnabled = newValue
            if newValue {
                loginButton.backgroundColor = .mainColor
            } else {
                loginButton.backgroundColor = .backgroundColor
            }
        }
    }

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "Войти",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                    .foregroundColor: UIColor.black
                ]
            ),
            for: .normal
        )
        button.isEnabled = false
        button.backgroundColor = .backgroundColor
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 54, bottom: 4, right: 54)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)

        return button
    }()

    private lazy var becomeStylistButton: UIButton = {
        let button = UIButton()
        let title = "Нажав \"Войти\", ты соглашаешься с условиями использования сервиса TiLcher"
        let range = (title as NSString).range(of: "с условиями")
        let attributedTitle = NSMutableAttributedString(
            string: title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .regular),
                .foregroundColor: UIColor.white
            ]
        )
        attributedTitle.addAttribute(.foregroundColor, value: UIColor.mainColor, range: range)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(beacomeStylist), for: .touchUpInside)

        return button
    }()

    init(
        onEditingChange: @escaping EditingChangeHandler,
        onLoginTap: @escaping () -> Void,
        onBecomeStylistTap: @escaping () -> Void
    ) {
        self.onLoginTap = onLoginTap
        self.onBecomeStylistTap = onBecomeStylistTap
        super.init(onEditingChange: onEditingChange)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setUp() {
        super.setUp()
        title = "Твой личный стилист"
        textField.keyboardType = .numberPad

        [
            loginButton,
            becomeStylistButton
        ]
        .forEach(addSubview)

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(34)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }

        becomeStylistButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(34)
            make.bottom.equalToSuperview().offset(-48)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
    }

    @objc
    func login() {
        onLoginTap()
    }

    @objc
    func beacomeStylist() {
        onBecomeStylistTap()
    }
}

