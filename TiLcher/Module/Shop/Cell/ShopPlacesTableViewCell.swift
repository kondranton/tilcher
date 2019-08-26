import UIKit
import SnapKit
import GoogleMaps

final class ShopPlacesTableViewCell: UnderlayedTableViewCell {
    private var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "selected_pin")
        return imageView
    }()

    private var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .bold)

        return label
    }()

    lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 17.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: .init())
        mapView.layer.cornerRadius = 8
        mapView.layer.masksToBounds = true
        mapView.setMinZoom(10, maxZoom: 19)
        mapView.delegate = self

        return mapView
    }()

    var markers = [(GMSMarker, Shop.Place)]()

    func setUp(with models: [Shop.Place]) {
        guard let firstPlace = models.first else {
            return
        }
        addressLabel.text = firstPlace.address

        let bounds = mapBounds(
            including: models.map {
                CLLocationCoordinate2D(
                    latitude: $0.location.latitude,
                    longitude: $0.location.longitude
                )
            }
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.mapView.moveCamera(GMSCameraUpdate.fit(bounds, withPadding: 48))
        }

        markers = []
        for model in models {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: model.location.latitude,
                longitude: model.location.longitude
            )

            marker.map = mapView

            if model == firstPlace {
                marker.icon = UIImage(named: "selected_pin")
                mapView.selectedMarker = marker
            } else {
                marker.icon = UIImage(named: "pin")
            }

            markers.append((marker, model))
        }
    }

    func mapBounds(including coordinates: [CLLocationCoordinate2D]) -> GMSCoordinateBounds {
        var bounds = GMSCoordinateBounds()
        for coordinate in coordinates {
            bounds = bounds.includingCoordinate(coordinate)
        }
        return bounds
    }

    override func setUp() {
        super.setUp()

        [
            pinImageView,
            addressLabel,
            mapView
        ]
        .forEach(underlayView.addSubview)

        pinImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(20)
            make.width.equalTo(13)
        }

        addressLabel.snp.makeConstraints { make in
            make.leading.equalTo(pinImageView.snp.trailing).offset(16)
            make.centerY.equalTo(pinImageView)
            make.trailing.equalToSuperview().offset(-16)
        }

        mapView.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(150)
        }
    }
}

extension ShopPlacesTableViewCell: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // view related selection
        if let selectedMarker = mapView.selectedMarker {
            selectedMarker.icon = UIImage(named: "pin")
        }
        mapView.selectedMarker = marker
        marker.icon = UIImage(named: "selected_pin")

        //business selection
        guard
            let selectedAddress = markers.first(where: { $0.0 == marker })?.1.address
        else {
            return false
        }
        addressLabel.text = selectedAddress

        return true
    }
}
