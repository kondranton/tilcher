import SnapKit

class HeaderedTableViewCell: UITableViewCell, ViewReusable {
    var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .subtitleColor
        label.font = .systemFont(ofSize: 17, weight: .bold)

        return label
    }()

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

        contentView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
