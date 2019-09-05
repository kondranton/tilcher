import UIKit

final class NameAuthViewController: UIViewController {
    var onEditingChange: EditingChangeHandler
    var onNext: (String) -> Void

    private lazy var nameInputView: FieldFormView = {
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

        nameInputView.title = "Как тебя зовут?"
        nameInputView.textField.placeholder = "Имя"
        view.addSubview(nameInputView)
        nameInputView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        nameInputView.isNextEnabled = false
        nameInputView.textField.addTarget(
            self,
            action: #selector(textChanged),
            for: .allEditingEvents
        )

        self.view = view
    }

    private func nextTap() {
        guard let text = nameInputView.textField.text else {
            return
        }
        onNext(text)
    }

    @objc
    private func textChanged() {
        nameInputView.isNextEnabled = !(nameInputView.textField.text?.isEmpty ?? true)
    }
}
