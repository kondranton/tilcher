import SnapKit

final class UserTypeViewController: UIViewController {
    var onBack: () -> Void
    var onNext: (UserRole) -> Void

    init(
        onBack: @escaping () -> Void,
        onNext: @escaping (UserRole) -> Void
    ) {
        self.onBack = onBack
        self.onNext = onNext
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()

        let subview = UserTypeView(
            onNextTap: { [weak self] selectedIndex in
                self?.onNext(selectedIndex == 0 ? .stylist : .consumer)
            },
            onBackTap: onBack
        )

        view.addSubview(subview)
        subview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.view = view
    }
}
