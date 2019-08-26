import SnapKit

final class FieldFormView: AuthFormView {
    var onBackTap: (() -> Void)?
    var onNextTap: () -> Void

    private lazy var navigationView: AuthNavigationView = {
        let navigationView = AuthNavigationView(
            onNextTap: onNextTap,
            onBackTap: onBackTap
        )

        return navigationView
    }()

    init(
        onEditingChange: @escaping EditingChangeHandler,
        onNextTap: @escaping () -> Void,
        onBackTap: (() -> Void)? = nil
    ) {
        self.onNextTap = onNextTap
        self.onBackTap = onBackTap
        super.init(onEditingChange: onEditingChange)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setUp() {
        super.setUp()

        addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(34)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
    }
}
