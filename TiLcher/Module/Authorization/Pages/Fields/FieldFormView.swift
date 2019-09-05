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

    var isNextEnabled: Bool {
        get {
            return navigationView.isNextEnabled
        }
        set {
            navigationView.isNextEnabled = newValue
        }
    }

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
            make.height.equalTo(40)
            make.leading.equalTo(textField)
            make.trailing.equalTo(textField)
        }
    }
}
