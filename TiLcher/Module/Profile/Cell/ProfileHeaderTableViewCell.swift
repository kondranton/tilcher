import UIKit

class ProfileHeaderTableViewCell: UITableViewCell, ViewReusable {
    func setUp(with model: ProfileHeaderItemModel) {
        moneyLabel.text = "\(model.money)"
        pointsLabel.text = "\(model.points)"
        nameLabel.text = model.name
    }

    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 68
        return imageView
    }()

    private var moneyLabel: UILabel = {
        let label = UILabel()
        label.text = "1200"
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private var moneyNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "рублей"
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()

    private var pointsLabel: UILabel = {
        let label = UILabel()
        label.text = "1200"
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private var pointsNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "балла"
        label.textColor = .secondaryColor
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Татьяна Ильчишина"
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private var pointsUnderlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.layer.cornerRadius = 36
        view.layer.masksToBounds = true
        return view
    }()

    private var underlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    private func setUp() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        [
            underlayView,
            pointsUnderlayView,
            photoImageView,
            pointsLabel,
            pointsNoteLabel,
            moneyLabel,
            moneyNoteLabel,
            nameLabel
        ]
        .forEach(addSubview)

        underlayView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(85 + 12)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-12)
        }

        photoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(136)
            make.width.equalTo(136)
            make.bottom.equalTo(nameLabel.snp.top).offset(-12)
        }

        pointsLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView.snp.trailing).offset(16)
            make.centerY.equalTo(pointsUnderlayView.snp.centerY)
        }

        pointsNoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(pointsLabel.snp.trailing).offset(4)
            make.bottom.equalTo(pointsLabel.snp.bottom).offset(-4)
        }

        moneyLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView.snp.trailing).offset(16)
            make.top.equalTo(photoImageView.snp.top).offset(4)
        }

        moneyNoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(moneyLabel.snp.trailing).offset(4)
            make.bottom.equalTo(moneyLabel.snp.bottom).offset(-4)
        }

        pointsUnderlayView.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(photoImageView.snp.centerX)
            make.centerY.equalTo(underlayView.snp.top)
        }
    }
}
