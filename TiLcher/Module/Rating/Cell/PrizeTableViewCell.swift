import UIKit

final class PrizeTableViewCell: UITableViewCell, ViewReusable {
    func setUp(with model: Int) {
        self.numberLabel.text = "\(model)"
        self.daysNoteLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("days", comment: ""),
            model
        )
    }

    private var underlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    private var untilPrizeNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "До вручения приза осталось"
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .light)

        return label
    }()

    private var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 24, weight: .bold)

        return label
    }()

    private var daysNoteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .light)

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        let stackView = UIStackView(
            arrangedSubviews: [
                self.untilPrizeNoteLabel,
                self.numberLabel,
                self.daysNoteLabel
            ]
        )
        stackView.spacing = 8

        self.addSubview(underlayView)
        self.underlayView.addSubview(stackView)

        self.underlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.bottom.top.equalToSuperview().inset(24)
        }
    }
}
