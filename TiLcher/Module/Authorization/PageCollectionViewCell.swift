import UIKit

final class PageCollectionViewCell: UICollectionViewCell, ViewReusable {
    override func prepareForReuse() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
    func layout(view: UIView) {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
