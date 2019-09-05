import UIKit
import SnapKit

final class ShopReviewInfoTableViewCell: UnderlayedTableViewCell {
    private var shopTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)

        return label
    }()

    private var clothesTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 10, weight: .regular)

        return label
    }()

    private lazy var instagramButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.setImage(
            UIImage(named: "publication"),
            for: .normal
        )
        button.addTarget(self, action: #selector(instagramTap), for: .touchUpInside)

        return button
    }()

    var onInstagramTap: (() -> Void)?

    func setUp(with model: Shop, onInstagramTap: @escaping () -> Void) {
        shopTypeLabel.text = model.shopCategories.first?.displayValue
        clothesTypeLabel.text = (model.goodsCategories
            .compactMap { $0.displayValue })
            .joined(separator: "/")
            .lowercased()
        self.onInstagramTap = onInstagramTap
    }

    @objc
    func instagramTap() {
        onInstagramTap?()
    }

    override func setUp() {
        super.setUp()

        selectionStyle = .none

        [
            shopTypeLabel,
            clothesTypeLabel,
            instagramButton
        ]
        .forEach(underlayView.addSubview)

        shopTypeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(instagramButton.snp.leading).offset(-8)
        }

        clothesTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(shopTypeLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-19)
            make.trailing.equalTo(instagramButton.snp.leading).offset(-8)
        }

        instagramButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
        }
    }
}

