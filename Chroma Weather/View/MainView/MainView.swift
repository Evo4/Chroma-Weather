//
//  MainVC.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 18.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import CoreLocation
import RxCoreLocation
import RxSwift
import RxCocoa
import GooglePlaces
import RealmSwift
import RxRealm
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

class MainView: UIViewController {

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 19)
        label.textColor = #colorLiteral(red: 0.07450980392, green: 0.05490196078, blue: 0.3176470588, alpha: 1)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Search-Dark"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()

    private lazy var forecastTypeCollectionView: ForecastTypeCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = ForecastTypeCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var currentWeatherView: WeatherInfoView = {
        let view = WeatherInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tomorrowWeatherView: WeatherInfoView = {
        let view = WeatherInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private lazy var nextWeekForecastView: NextWeekForecastView = {
        let view = NextWeekForecastView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private lazy var sideMenuBackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.35)
        view.alpha = 0
        return view
    }()
    
    private lazy var sideMenuView: SideMenuView = {
        let view = SideMenuView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var sideMenuLeftAnchor: NSLayoutConstraint!
    var sideMenuRightAnchor: NSLayoutConstraint!
    
    private let mainViewModel = MainViewModel()
    let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupConstraints()
        setupRealmBinding()
        setupForecast()
        setupSideMenu()
        
        NotificationService.shared.initNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        Settings.shared.serializeBangeCounter(badge: NSNumber(value: 1))
        
        forecastTypeCollectionView.forecastTypeCallback = { [weak self] type in
            switch type {
            case 0:
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                    self?.tomorrowWeatherView.alpha = 0
                    self?.nextWeekForecastView.alpha = 0
                    self?.currentWeatherView.alpha = 1
                }, completion: nil)
                break
            case 1:
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                    self?.currentWeatherView.alpha = 0
                    self?.nextWeekForecastView.alpha = 0
                    self?.tomorrowWeatherView.alpha = 1
                }, completion: nil)
                break
            case 2:
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                    self?.currentWeatherView.alpha = 0
                    self?.tomorrowWeatherView.alpha = 0
                    self?.nextWeekForecastView.alpha = 1
                }, completion: nil)
                break
            default:
                break
            }
        }
        
        searchButton.rx.tap
            .bind(onNext: { [weak self] in
                let autocompleteController = GMSAutocompleteViewController()
                autocompleteController.delegate = self

                // Specify the place data types to return.
                let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                  UInt(GMSPlaceField.placeID.rawValue))!
                autocompleteController.placeFields = fields

                // Specify a filter.
                let filter = GMSAutocompleteFilter()
                filter.type = .city
                autocompleteController.autocompleteFilter = filter

                // Display the autocomplete view controller.
                self?.present(autocompleteController, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        menuButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.mainViewModel.isSideMenuHidden.onNext(false)
            }).disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mainViewModel.isSideMenuHidden.onNext(true)
    }
    
    fileprivate func setupConstraints() {
        [locationLabel, searchButton, menuButton, forecastTypeCollectionView, currentWeatherView, tomorrowWeatherView, nextWeekForecastView, sideMenuBackView, sideMenuView].forEach { (subview) in
            view.addSubview(subview)
        }
        
        sideMenuLeftAnchor = sideMenuView.leftAnchor.constraint(equalTo: view.leftAnchor)
        sideMenuRightAnchor = sideMenuView.rightAnchor.constraint(equalTo: view.leftAnchor)
        
        NSLayoutConstraint.activate([
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            searchButton.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            searchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            searchButton.widthAnchor.constraint(equalToConstant: 20),
            searchButton.heightAnchor.constraint(equalTo: searchButton.widthAnchor),
            
            menuButton.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            menuButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            menuButton.widthAnchor.constraint(equalToConstant: 20),
            menuButton.heightAnchor.constraint(equalTo: searchButton.widthAnchor),
            
            locationLabel.leftAnchor.constraint(equalTo: menuButton.rightAnchor, constant: 20),
            locationLabel.rightAnchor.constraint(equalTo: searchButton.leftAnchor, constant: -20),
            
            forecastTypeCollectionView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 30),
            forecastTypeCollectionView.widthAnchor.constraint(equalToConstant: 270),
            forecastTypeCollectionView.heightAnchor.constraint(equalToConstant: 40),
            forecastTypeCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            currentWeatherView.topAnchor.constraint(equalTo: forecastTypeCollectionView.bottomAnchor, constant: 30),
            currentWeatherView.leftAnchor.constraint(equalTo: menuButton.leftAnchor),
            currentWeatherView.rightAnchor.constraint(equalTo: searchButton.rightAnchor),
            currentWeatherView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            tomorrowWeatherView.topAnchor.constraint(equalTo: forecastTypeCollectionView.bottomAnchor, constant: 30),
            tomorrowWeatherView.leftAnchor.constraint(equalTo: menuButton.leftAnchor),
            tomorrowWeatherView.rightAnchor.constraint(equalTo: searchButton.rightAnchor),
            tomorrowWeatherView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            nextWeekForecastView.topAnchor.constraint(equalTo: forecastTypeCollectionView.bottomAnchor, constant: 30),
            nextWeekForecastView.leftAnchor.constraint(equalTo: view.leftAnchor),
            nextWeekForecastView.rightAnchor.constraint(equalTo: view.rightAnchor),
            nextWeekForecastView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            sideMenuBackView.topAnchor.constraint(equalTo: view.topAnchor),
            sideMenuBackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            sideMenuBackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            sideMenuBackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            sideMenuView.topAnchor.constraint(equalTo: sideMenuBackView.topAnchor),
            sideMenuRightAnchor!,
            sideMenuView.bottomAnchor.constraint(equalTo: sideMenuBackView.bottomAnchor),
            sideMenuView.widthAnchor.constraint(equalTo: sideMenuBackView.widthAnchor, multiplier: 0.7),
        ])
    }
    
    fileprivate func setupSideMenu() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeSideMenu))
        sideMenuBackView.addGestureRecognizer(gesture)
        
        let leftGesture = UIPanGestureRecognizer(target: self, action: #selector(sideMenuGesture(sender:)))
        sideMenuView.addGestureRecognizer(leftGesture)
        
        mainViewModel.isSideMenuHidden.asObservable()
            .observeOn(MainScheduler.instance)
            .startWith(true)
            .subscribe(onNext: { [weak self] isSideMenuHidden in
                switch isSideMenuHidden {
                case true:
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.sideMenuLeftAnchor.isActive = false
                        self?.sideMenuRightAnchor.isActive = true
                        self?.sideMenuBackView.alpha = 0
                        self?.view.layoutIfNeeded()
                    }
                case false:
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.sideMenuRightAnchor.isActive = false
                        self?.sideMenuLeftAnchor.isActive = true
                        self?.sideMenuBackView.alpha = 1
                        self?.view.layoutIfNeeded()
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    @objc fileprivate func closeSideMenu() {
        mainViewModel.isSideMenuHidden.onNext(true)
    }
    
    @objc fileprivate func sideMenuGesture(sender: UIPanGestureRecognizer) {
        let pos = sender.translation(in: sideMenuView)
        let velocity = sender.velocity(in: sideMenuView)
        let constant = pos.x
        if constant <= 0 {
            sideMenuLeftAnchor.constant = constant
        }
        if sender.state == UIPanGestureRecognizer.State.ended {
            if constant >= -105 {
                if velocity.x <= -650 {
                    sideMenuLeftAnchor.constant = 0
                    mainViewModel.isSideMenuHidden.onNext(true)
                    return
                }
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.sideMenuLeftAnchor.constant = 0
                    self?.view.layoutIfNeeded()
                }
                return
            }
            if constant <= 105 {
                sideMenuLeftAnchor.constant = 0
                mainViewModel.isSideMenuHidden.onNext(true)
                return
            }
        }
    }
    
    fileprivate func setupRealmBinding() {
        if mainViewModel.realmLocations.count == 0 {
            let location = locationManager.location ?? CLLocation(latitude: 47.858176, longitude: 35.103274)
            let realmLocation = RealmLocation()
            realmLocation.latitude = location.coordinate.latitude
            realmLocation.longitude = location.coordinate.longitude

            try! mainViewModel.realm.write {
                mainViewModel.realm.add(realmLocation)
            }
        }
        
        Observable.arrayWithChangeset(from: mainViewModel.realmLocations)
            .subscribe(onNext: { [weak self] array, changes in
                let location = CLLocation(latitude: array[0].latitude, longitude: array[0].longitude)
                if let _ = changes {
                    self?.mainViewModel.location.asObserver().onNext(location)
                } else {
                    self?.mainViewModel.location.asObserver().onNext(location)
                }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func setupForecast() {
        let location = CLLocation(latitude: mainViewModel.realmLocations[0].latitude, longitude: mainViewModel.realmLocations[0].longitude)
        
        mainViewModel.location
            .asObservable()
            .startWith(location)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (location) in
                APIProvider.shared.getCurrentForecast(location: location) { (result) in
                switch result {
                    case .success(let forecast):
                        self?.mainViewModel.currentForecast.asObserver().onNext(forecast)
                        self?.currentWeatherView.forecastInfoAlpha = 1
                        break
                    case .failure(()):
                        break
                    }
                }
            }).disposed(by: disposeBag)
        
        mainViewModel.location
            .asObservable()
            .startWith(location)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (location) in
                APIProvider.shared.getOneCallForecast(location: location) { (result) in
                switch result {
                    case .success(let forecast):
                        self?.mainViewModel.oneCallForecast.asObserver().onNext(forecast)
                        self?.tomorrowWeatherView.forecastInfoAlpha = 1
                        break
                    case .failure(()):
                        break
                    }
                }
            }).disposed(by: disposeBag)
        
        mainViewModel.getLocationName()
            .observeOn(MainScheduler.instance)
            .bind(to: locationLabel.rx.text)
            .disposed(by: disposeBag)
        
        if let forecast = Settings.shared.currentForecast {
            mainViewModel.currentForecast
                .asObservable()
                .observeOn(MainScheduler.instance)
                .startWith(forecast)
                .bind(to: currentWeatherView.currentForecast)
                .disposed(by: disposeBag)
        } else {
            mainViewModel.currentForecast
                .asObservable()
                .observeOn(MainScheduler.instance)
                .bind(to: currentWeatherView.currentForecast)
                .disposed(by: disposeBag)
        }
        
        mainViewModel.forecastTypes.asObservable()
            .startWith([
                ForecastType(type: .today),
                ForecastType(type: .tomorrow),
                ForecastType(type: .nextWeek),
            ])
            .observeOn(MainScheduler.instance)
            .bind(to: forecastTypeCollectionView.forecastTypes)
            .disposed(by: disposeBag)
        
        mainViewModel.todayHourlyForecast
        .observeOn(MainScheduler.instance)
        .bind(to: currentWeatherView.hourlyForecasts.asObserver())
        .disposed(by: disposeBag)
        
        mainViewModel.tomorrowForecast
            .observeOn(MainScheduler.instance)
            .bind(to: tomorrowWeatherView.currentForecast)
            .disposed(by: disposeBag)
        
        mainViewModel.tomorrowForecast
            .observeOn(MainScheduler.instance)
            .map {
                return $0.hourlyForecast
            }.subscribe(onNext: { [weak self] (listHourlyForecast) in
                let hourlyForecast = Array(listHourlyForecast)
                self?.tomorrowWeatherView.hourlyForecasts.asObserver().onNext(hourlyForecast)
            }).disposed(by: disposeBag)
        
        mainViewModel.dailyForecasts
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: nextWeekForecastView.forecasts)
            .disposed(by: disposeBag)
    }
    
    fileprivate func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
}

extension MainView: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    getCoordinateFrom(address: place.name ?? "") { [weak self] coordinate, error in
        guard let coordinate = coordinate, error == nil else { return }
        
        let locations = self!.mainViewModel.realm.objects(RealmLocation.self)
        try! self?.mainViewModel.realm.write {
            locations[0].latitude = coordinate.latitude
            locations[0].longitude = coordinate.longitude
        }

    }
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}
