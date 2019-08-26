import SnapKit

final class ResultInputView: UIView {
    private var textField: UITextField = {
        let textField = AnimatedPlaceholderTextField()
        textField.color = .secondaryColor
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textChaned), for: .allEditingEvents)
        return textField
    }()

    var placeholder: String? {
        get {
            return textField.placeholder
        }
        set {
            textField.placeholder = newValue
        }
    }

    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }

    var keyboardType: UIKeyboardType {
        get {
            return textField.keyboardType
        }
        set {
            textField.keyboardType = newValue
        }
    }

    var onTextChange: ((String) -> Void)?

    init() {
        super.init(frame: .zero)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func textChaned() {
        onTextChange?(textField.text ?? "")
    }

    private func setUp() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true

        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}
