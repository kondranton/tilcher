import UIKit

final class NameAuthViewController: UIViewController {
    var onEditingChange: EditingChangeHandler
    var onNext: (String) -> Void

    private lazy var subview: FieldFormView = {
        FieldFormView(
            onEditingChange: { [weak self] isEditing in
                self?.onEditingChange(isEditing)
            },
            onNextTap: { [weak self] in
                self?.nextTap()
            }
        )
    }()

    init(
        onEditingChange: @escaping EditingChangeHandler,
        onNext: @escaping (String) -> Void
    ) {
        self.onEditingChange = onEditingChange
        self.onNext = onNext
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()

        subview.title = "Как тебя зовут?"
        subview.textField.placeholder = "Имя"
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
