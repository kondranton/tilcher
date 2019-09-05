import SnapKit

final class CodeVerificationView: AuthFormView {
    enum State {
        case resendCode, waitForResend
    }

    var state = State.resendCode {
        didSet {
            switch state {
            case .resendCode:
                resendNoticeLabel.isHidden = true
                resendSmsButton.isHidden = false
            case .waitForResend:
                resendNoticeLabel.isHidden = false
                resendSmsButton.isHidden = true
            }
        }
    }

    var resendNoticeText: String? {
        get {
            return resendNoticeLabel.text
        }
        set {
            resendNoticeLabel.text = newValue
        }
    }

    private var onNextTap: () -> Void
    private var onBackTap: () -> Void
    private var onResendTap: () -> Void

    private lazy var navigationView: AuthNavigationView = {
        let navigationView = AuthNavigationView(
            onNextTap: onNextTap,
            onBackTap: onBackTap
        )

        return navigationView
    }()

    var isNextEnabled: Bool {
        get {
            return navigationView.isNextEnabled
        }
        set {
            navigationView.isNextEnabled = newValue
        }
    }

    lazy var resendSmsButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "Отправить смс заново",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                    .foregroundColor: UIColor.mainColor
                ]
            ),
            for: .normal
        )
        button.addTarget(self, action: #selector(resendTap), for: .touchUpInside)

        return button
    }()

    private var resendNoticeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 2

        return label
    }()

    init(
        onEditingChange: @escaping EditingChangeHandler,
        onNextTap: @escaping () -> Void,
        onBackTap: @escaping () -> Void,
        onResendTap: @escaping () -> Void
    ) {
        self.onNextTap = onNextTap
        self.onBackTap = onBackTap
        self.onResendTap = onResendTap
        super.init(onEditingChange: onEditingChange)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func nextTap() {
        onNextTap()
    }

    @objc
    private func backTap() {
        onBackTap()
    }

    @objc
    private func resendTap() {
        onResendTap()
    }

    override func setUp() {
        super.setUp()
        title = "Какой код пришел в смс?"
        textField.placeholder = "Код"
        textField.isSecureTextEntry = true

        [
            resendNoticeLabel,
            resendSmsButton,
            navigationView
        ]
        .forEach(addSubview)

        navigationView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(34)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.leading.equalTo(textField)
            make.trailing.equalTo(textField)
        }

        resendSmsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom).offset(34)
            make.bottom.equalToSuperview().offset(-48)
        }

        resendNoticeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom).offset(34)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
