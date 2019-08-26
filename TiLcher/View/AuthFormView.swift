import UIKit
import SnapKit

typealias EditingChangeHandler = (Bool) -> Void

class AuthFormView: UIView {
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    var onEditingChange: EditingChangeHandler

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    var textField: UITextField = {
        let textField = AnimatedPlaceholderTextField()
        textField.placeholder = "Телефон"
        textField.textColor = .white
        textField.inputAccessoryView = nil
        textField.autocorrectionType = .no
        textField.addTarget(
            self,
            action: #selector(editingChanged(textField:)),
            for: .editingDidBegin
        )
        textField.addTarget(
            self,
            action: #selector(editingChanged(textField:)),
            for: .editingDidEnd
        )

        return textField
    }()

    init(onEditingChange: @escaping EditingChangeHandler) {
        self.onEditingChange = onEditingChange
        super.init(frame: .zero)
        self.setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func editingChanged(textField: UITextField) {
        onEditingChange(textField.isEditing)
    }

    func setUp() {
        backgroundColor = .blackTransparentColor
        layer.cornerRadius = 20
        layer.masksToBounds = true

        [
            titleLabel,
            textField
        ]
        .forEach(addSubview)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
            make.top.equalToSuperview().offset(48)
        }

        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
            make.centerY.equalToSuperview()
        }
    }
}
