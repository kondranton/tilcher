import SnapKit

final class UserTypeView: UIView {
    private var onNextTap: (Int) -> Void
    private var onBackTap: () -> Void

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    var switchView: SwitchView = {
        let view = SwitchView()
        view.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        return view
    }()

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
        button.backgroundColor = .mainColor
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

    init(
        onNextTap: @escaping (Int) -> Void,
        onBackTap: @escaping () -> Void
    ) {
        self.onNextTap = onNextTap
        self.onBackTap = onBackTap
        super.init(frame: .zero)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func switchChanged() {
    }

    @objc
    private func nextTap() {
        onNextTap(switchView.isRightSelected ? 1 : 0)
    }

    @objc
    private func backTap() {
        onBackTap()
    }

    func setUp() {
        backgroundColor = .blackTransparentColor
        layer.cornerRadius = 20
        layer.masksToBounds = true

        titleLabel.text = "Ты стилист?"

        [
            titleLabel,
            switchView,
            nextButton,
            backButton
        ]
        .forEach(addSubview)

        let buttonsLayoutGuide = UILayoutGuide()
        addLayoutGuide(buttonsLayoutGuide)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
            make.top.equalToSuperview().offset(48)
        }

        switchView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(38)
            make.centerY.equalToSuperview().offset(-32)
        }

        buttonsLayoutGuide.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(switchView.snp.bottom).offset(34)
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
    }
}
