import SnapKit

final class InputFieldTableViewCell: UITableViewCell, ViewReusable {
    let textInputView: ResultInputView = {
        let view = ResultInputView()
        view.placeholder = "Луки"
        return view
    }()

    func setUp(
        placeholder: String,
        value: String,
        keyboardType: UIKeyboardType = .numberPad,
        textChange: @escaping (String) -> Void
    ) {
        textInputView.placeholder = placeholder
        textInputView.text = value
        textInputView.keyboardType = keyboardType
        textInputView.onTextChange = textChange
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        addSubview(textInputView)
        textInputView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
            make.height.equalTo(72)
        }
    }
}

