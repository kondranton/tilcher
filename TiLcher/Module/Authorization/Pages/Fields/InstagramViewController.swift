import UIKit

final class InstagramFormViewController: UIViewController {
    var onEditingChange: EditingChangeHandler
    var onBack: () -> Void
    var onNext: (String) -> Void

    private lazy var subview: FieldFormView = {
        FieldFormView(
            onEditingChange: { [weak self] isEditing in
                self?.onEditingChange(isEditing)
            },
            onNextTap: { [weak self] in
                self?.nextTap()
            },
            onBackTap: { [weak self] in
                self?.onBack()
            }
        )
    }()

    init(
        onEditingChange: @escaping EditingChangeHandler,
        onBack: @escaping () -> Void,
        onNext: @escaping (String) -> Void
    ) {
        self.onEditingChange = onEditingChange
        self.onBack = onBack
        self.onNext = onNext
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()

        subview.title = "Твой ник в Instagram?"
        subview.textField.placeholder = "Ник"
        view.addSubview(subview)
        subview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.view = view
    }

    private func nextTap() {
        guard let text = subview.textField.text else {
            return
        }
        onNext(text)
    }
}
