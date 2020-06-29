//
//  MapView.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 27.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import RxGoogleMaps
import GoogleMaps
import RxCocoa
import RxSwift

class MapView: UIViewController {

    private lazy var mapView: GMSMapView = {
        let view = GMSMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var marker: GMSMarker!
    
    let mainViewModel = MainViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupConstraints()
        setupInitialLocation()
        
        let leftBarButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissAction))
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        mapView.rx.didTapAt
            .asObservable()
            .subscribe(onNext: { [weak self] (coordinate) in
                self?.marker.map = nil
                self?.marker = GMSMarker(position: coordinate)
                self?.marker.map = self?.mapView
                
                let locations = self!.mainViewModel.realm.objects(RealmLocation.self)
                try! self?.mainViewModel.realm.write {
                    locations[0].latitude = coordinate.latitude
                    locations[0].longitude = coordinate.longitude
                }
                self?.mainViewModel.location.onNext(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
            }).disposed(by: disposeBag)
        
        mainViewModel.getLocationName()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] locationName in
                self?.title = locationName
            }).disposed(by: disposeBag)
        
    }
    
    fileprivate func setupConstraints() {
        [mapView].forEach { (subview) in
            view.addSubview(subview)
        }
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    fileprivate func setupInitialLocation() {
        mainViewModel.location
            .asObservable()
            .startWith(CLLocation(latitude: mainViewModel.realmLocations[0].latitude, longitude: mainViewModel.realmLocations[0].longitude))
            .map {
                return GMSCameraPosition(target: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude), zoom: 10)
        }.bind(to: mapView.rx.camera)
        .disposed(by: disposeBag)
        
        marker = GMSMarker(position: mapView.camera.target)
        marker.map = mapView
    }
    
    @objc fileprivate func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
}
