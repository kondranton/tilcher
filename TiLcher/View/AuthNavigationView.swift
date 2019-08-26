import SnapKit

final class AuthNavigationView: UIView {
    private var onNextTap: () -> Void
    private var onBackTap: (() -> Void)?

    private lazy var backButton: UIButton = {
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

    private lazy var nextButton: UIButton = {
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

    init(
        onNextTap: @escaping () -> Void,
        onBackTap: (() -> Void)?
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
    func backTap() {
        onBackTap?()
    }

    @objc
    func nextTap() {
        onNextTap()
    }

    func setUp() {
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()

            if onBackTap != nil {
                make.trailing.equalToSuperview()
            } else {
                make.width.equalToSuperview().multipliedBy(0.6)
                make.centerX.equalToSuperview()
            }
        }

        if onBackTap != nil {
            addSubview(backButton)
            backButton.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalToSuperview()
                make.trailing.equalTo(nextButton.snp.leading)
            }
        }
    }
}
