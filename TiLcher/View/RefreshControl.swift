import UIKit
import SnapKit
import NVActivityIndicatorView

final class SpinnerRefreshControl: UIRefreshControl {
    private static let spinnerHeight: CGFloat = 25.0

    private var isInited = false
    private lazy var spinnerView = NVActivityIndicatorView(
        frame: frame,
        type: .squareSpin,
        color: .mainColor,
        padding: 0
    )

    override func layoutSubviews() {
        super.layoutSubviews()

        if !isInited {
            isInited = true
            setupSubviews()
        }
    }

    func updateScrollState() {
        let pullRatio = min(
            1.0,
            bounds.height / SpinnerRefreshControl.spinnerHeight
        )

        spinnerView.alpha = pullRatio
    }

    private func setupSubviews() {
        backgroundColor = .clear
        tintColor = .clear
        addSubview(spinnerView)
        spinnerView.startAnimating()
        spinnerView.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(25)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
