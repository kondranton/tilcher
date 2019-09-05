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

    private lazy var navigationView: AuthNavigationView = {
        let navigationView = AuthNavigationView(
            onNextTap: { [weak self] in
                self?.nextTap()
            },
            onBackTap: onBackTap
        )

        return navigationView
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

    func setUp() {
        backgroundColor = .blackTransparentColor
        layer.cornerRadius = 20
        layer.masksToBounds = true

        titleLabel.text = "Ты стилист?"

        [
            titleLabel,
            switchView,
            navigationView
        ]
        .forEach(addSubview)

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

        navigationView.snp.makeConstraints { make in
            make.top.equalTo(switchView.snp.bottom).offset(34)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
