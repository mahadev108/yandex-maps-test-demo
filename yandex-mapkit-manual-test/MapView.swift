//
//  MapView.swift
//  yandex-mapkit-manual-test
//
//  Created by Shukhrat Sagatov on 05.03.2021.
//

import UIKit
import YandexMapsMobile

class MapView: YMKMapView {
    private lazy var locationManager = YMKMapKit.sharedInstance().createLocationManager()
    private lazy var userLocationLayer: YMKUserLocationLayer = {
        let layer = YMKMapKit.sharedInstance().createUserLocationLayer(with: mapWindow)
        layer.setVisibleWithOn(true)
        layer.setObjectListenerWith(self)
        return layer
    }()

    var drivingSessions: [UUID: YMKDrivingSession] = [:]

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }

    private func commonSetup() {
        mapWindow.map.setMapLoadedListenerWith(self)
    }
}

extension MapView: YMKMapLoadedListener {
    func onMapLoaded(with statistics: YMKMapLoadStatistics) {
        userLocationLayer.isHeadingEnabled = false
        loadAutomotiveDirections()
    }
}

extension MapView: YMKUserLocationObjectListener {
    func onObjectAdded(with view: YMKUserLocationView) {
        guard let headingImage = UIImage(named: "heading_indicator", in: nil, compatibleWith: nil),
              let iconImage = UIImage(named: "user_indicator", in: nil, compatibleWith: nil) else {
            return
        }
        view.pin.setIconWith(iconImage)
        let arrowPlacemark = view.arrow.useCompositeIcon()
        arrowPlacemark.setIconWithName(
            "icon",
            image: iconImage, style: YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType: YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 1,
                flat: true,
                visible: true,
                scale: 1,
                tappableArea: nil)
        )
        arrowPlacemark.setIconWithName(
            "heading",
            image: headingImage, style: YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType: YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 0,
                flat: true,
                visible: true,
                scale: 1,
                tappableArea: nil)
        )

    }

    func onObjectRemoved(with view: YMKUserLocationView) {
    }

    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
    }
}

extension MapView {
    private func loadAutomotiveDirections() {
        let ROUTE_START_POINT = YMKPoint(latitude: 59.959194, longitude: 30.407094)
        let ROUTE_END_POINT = YMKPoint(latitude: 64.735814, longitude: 177.518903)
        let requestPoints : [YMKRequestPoint] = [
            YMKRequestPoint(point: ROUTE_START_POINT, type: .waypoint, pointContext: nil),
            YMKRequestPoint(point: ROUTE_END_POINT, type: .waypoint, pointContext: nil),
        ]
        let drivingOptions = YMKDrivingDrivingOptions()
        drivingOptions.avoidTolls = NSNumber(booleanLiteral: true)
        let sessionUUID = UUID()
        let drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()
        let session = drivingRouter.requestRoutes(with: requestPoints, drivingOptions: drivingOptions, vehicleOptions: YMKDrivingVehicleOptions()) { [weak self] routes, error in
            self?.drivingSessions[sessionUUID] = nil
            if error != nil {
                print("ERROR loading routes!")
                return
            }
            if let route = routes?.first {
                self?.mapWindow.map.mapObjects.addPolyline(with: route.geometry)
            } else {
                print("Empty routes")
            }
        }
        drivingSessions[sessionUUID] = session
    }
}
