import UIKit

class PageCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var flowInset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    var cache = [UICollectionViewLayoutAttributes]()

    var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let itemsNumber = CGFloat(collectionView.numberOfItems(inSection: 0))
        return collectionView.bounds.width * itemsNumber
    }

    var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }

        return collectionView.frame.height
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()
        scrollDirection = .horizontal
    }

    override func invalidateLayout() {
        super.invalidateLayout()
        cache = []
    }

    override func prepare() {
        super.prepare()
        guard cache.isEmpty else {
            return
        }

        guard let collectionView = collectionView else {
            return
        }
        var xOffset = flowInset.left
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let itemWidth = collectionView.frame.width - 40
            attributes.frame = CGRect(
                x: xOffset,
                y: 0,
                width: itemWidth,
                height: collectionView.frame.height
            )
            cache.append(attributes)

            xOffset += itemWidth + 40
        }
    }

    override func layoutAttributesForElements(
        in rect: CGRect
    ) -> [UICollectionViewLayoutAttributes] {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
