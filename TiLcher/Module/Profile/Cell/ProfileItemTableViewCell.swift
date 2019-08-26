import UIKit
import Nuke

final class ProfileItemTableViewCell: UITableViewCell, ViewReusable {
    func setUp(with model: ProfileStatisticsItemModel) {
        nameLabel.text = model.itemType.name
        pointsLabel.text = "\(model.value)"
        photoImageView.image = UIImage(named: model.itemType.imageName)
    }

    private var underlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private var pointsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .mainColor
        label.layer.cornerRadius = 11
        label.layer.masksToBounds = true
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

    private func setUp() {
        backgroundColor = .backgroundColor
        contentView.backgroundColor = .backgroundColor
        selectionStyle = .none

        addSubview(underlayView)
        underlayView.snp.makeConstraints { make in
            make.height.equalTo(74)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }

        [
            photoImageView,
            nameLabel,
            pointsLabel
        ]
        .forEach(underlayView.addSubview)

        photoImageView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        pointsLabel.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(22)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView.snp.trailing).offset(16)
            make.trailing.equalTo(pointsLabel.snp.leading).offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}
