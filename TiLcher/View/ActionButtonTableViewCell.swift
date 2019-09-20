import UIKit
import SnapKit

final class ActionButtonTableViewCell: UITableViewCell, ViewReusable {
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 54, bottom: 4, right: 54)
        button.addTarget(self, action: #selector(actionButtonTap), for: .touchUpInside)

        return button
    }()

    var action: (() -> Void)?

    func setUp(with model: ActionButtonViewModel, action: @escaping () -> Void) {
        actionButton.setAttributedTitle(
            NSAttributedString(
                string: model.title,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                    .foregroundColor: UIColor.black
                ]
            ),
            for: .normal
        )
        actionButton.backgroundColor = model.isEnabled ? .mainColor : .white
        actionButton.isEnabled = model.isEnabled
        self.action = action
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

        contentView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-36)
            make.height.equalTo(48)
            make.top.equalToSuperview().offset(46)
            make.bottom.equalToSuperview().offset(-46)
        }
    }

    @objc
    private func actionButtonTap() {
        action?()
    }
}

