import UIKit
import SnapKit

final class ShopRewardsTableViewCell: UnderlayedTableViewCell {
    private var pointsView: RewardView = {
        let view = RewardView()
        view.title = "баллов за лук"
        return view
    }()

    private var comissionView: RewardView = {
        let view = RewardView()
        view.title = "с покупки - тебе"
        return view
    }()

    func setUp(with model: ShopAssignment.Rewards) {
        pointsView.number = "\(model.pointsForLook)"
        comissionView.number = "\(model.comission)%"
    }

    override func setUp() {
        super.setUp()

        let separatorView = UIView()
        separatorView.backgroundColor = .backgroundColor

        [
            pointsView,
            separatorView,
            comissionView
        ]
        .forEach(underlayView.addSubview)

        pointsView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(74)
        }

        separatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.width.equalTo(2)
        }

        comissionView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
}
