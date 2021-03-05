//
//  ViewController.swift
//  yandex-mapkit-manual-test
//
//  Created by Shukhrat Sagatov on 17.11.2020.
//

import UIKit
import YandexMapsMobile

class ViewController: UIViewController {
    private lazy var mapView = MapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.insertSubview(mapView, at: 0)
    }

    override func viewWillLayoutSubviews() {
        mapView.frame = view.bounds
    }
}
