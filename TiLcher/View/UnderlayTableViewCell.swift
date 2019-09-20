import UIKit
import Nuke

class UnderlayedTableViewCell: UITableViewCell, ViewReusable {
    var underlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            underlayView.backgroundColor = .backgroundColor
        } else {
            underlayView.backgroundColor = .white
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    func setUp() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        addSubview(underlayView)
        underlayView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
}
