import UIKit

final class InstagramFormViewController: UIViewController {
    var onEditingChange: EditingChangeHandler
    var onBack: () -> Void
    var onNext: (String) -> Void

    private lazy var instagramInputView: FieldFormView = {
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

        instagramInputView.title = "Твой ник в Instagram?"
        instagramInputView.isNextEnabled = false
        instagramInputView.textField.placeholder = "Ник"
        instagramInputView.textField.addTarget(
            self,
            action: #selector(textChanged),
            for: .allEditingEvents
        )

        view.addSubview(instagramInputView)
        instagramInputView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.view = view
    }

    private func nextTap() {
        guard let text = instagramInputView.textField.text else {
            return
        }
        onNext(text)
    }

    @objc
    private func textChanged() {
        instagramInputView.isNextEnabled = !(instagramInputView.textField.text?.isEmpty ?? true)
    }
}
