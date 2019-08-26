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

    var isNextEnabled: Bool {
        get {
            return nextButton.isEnabled
        }
        set {
            nextButton.isEnabled = newValue
            if newValue {
                nextButton.backgroundColor = .mainColor
            } else {
                nextButton.backgroundColor = .backgroundColor
            }
        }
    }

    private var onNextTap: () -> Void
    private var onBackTap: () -> Void
    private var onResendTap: () -> Void

    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "Далее",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                    .foregroundColor: UIColor.black
                ]
            ),
            for: .normal
        )
        button.backgroundColor = .backgroundColor
        button.isEnabled = false
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 54, bottom: 4, right: 54)
        button.addTarget(self, action: #selector(nextTap), for: .touchUpInside)

        return button
    }()

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "Назад",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                    .foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 30, bottom: 4, right: 30)
        button.addTarget(self, action: #selector(backTap), for: .touchUpInside)

        return button
    }()

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
            nextButton,
            backButton,
            resendNoticeLabel,
            resendSmsButton
        ]
        .forEach(addSubview)

        let buttonsLayoutGuide = UILayoutGuide()
        addLayoutGuide(buttonsLayoutGuide)

        buttonsLayoutGuide.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(34)
            make.height.equalTo(40)
        }

        nextButton.snp.makeConstraints { make in
            make.trailing.equalTo(buttonsLayoutGuide)
            make.top.equalTo(buttonsLayoutGuide)
            make.bottom.equalTo(buttonsLayoutGuide)
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalTo(buttonsLayoutGuide)
            make.bottom.equalTo(buttonsLayoutGuide)
            make.top.equalTo(buttonsLayoutGuide)
            make.trailing.equalTo(nextButton.snp.leading)
        }

        resendSmsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(buttonsLayoutGuide.snp.bottom).offset(34)
            make.bottom.equalToSuperview().offset(-48)
        }

        resendNoticeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(buttonsLayoutGuide.snp.bottom).offset(34)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
