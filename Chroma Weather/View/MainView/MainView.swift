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
        button.addTarget(self, action: #selector(searchAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(menuAction(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var forecastTypeCollectionView: ForecastTypeCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 25
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
    
    private let mainViewModel = MainViewModel()
    let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupConstraints()
        
        setupLocation()
        setupForecast()
        
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
    }
    
    func setupConstraints() {
        [locationLabel, searchButton, menuButton, forecastTypeCollectionView, currentWeatherView, tomorrowWeatherView, nextWeekForecastView].forEach { (subview) in
            view.addSubview(subview)
        }
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
            forecastTypeCollectionView.widthAnchor.constraint(equalToConstant: 265),
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
        ])
    }
    
    fileprivate func setupLocation() {
//        GMSServices.provideAPIKey("AIzaSyCMzwfJKAJ8TS__mt72EcopUc1VFpykwtQ")
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationLabel.text = Settings.shared.locationName
        
        locationManager.rx.location
            .map {$0 ?? CLLocation(latitude: 47.45, longitude: 35.10)}
            .observeOn(MainScheduler.instance)
            .asObservable()
            .bind(to: mainViewModel.location.asObserver())
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupForecast() {
        if let location = Settings.shared.locationName {
            mainViewModel.getLocationName()
                .observeOn(MainScheduler.instance)
                .startWith(location)
                .bind(to: locationLabel.rx.text)
                .disposed(by: disposeBag)
        } else {
            mainViewModel.getLocationName()
                .observeOn(MainScheduler.instance)
                .bind(to: locationLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        mainViewModel.location
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (location) in
                APIProvider.shared.getCurrentForecast(location: location) { (result) in
                    switch result {
                    case .success(let forecast):
                        self?.mainViewModel.currentForecast.onNext(forecast)
                        Settings.shared.serializeCurrentForecast(currentForecast: forecast)
                        break
                    case .failure(()):
                        break
                    }
                }
            }).disposed(by: disposeBag)
        
        mainViewModel.location
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (location) in
                APIProvider.shared.getOneCallForecast(location: location) { (result) in
                    switch result {
                    case .success(let forecast):
                        self?.mainViewModel.oneCallForecast.onNext(forecast)
//                        Settings.shared.serializeCurrentForecast(currentForecast: forecast)
                        break
                    case .failure(()):
                        break
                    }
                }
            }).disposed(by: disposeBag)
        
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
                return $0.hourlyForecast ?? []
            }.bind(to: tomorrowWeatherView.hourlyForecasts)
            .disposed(by: disposeBag)
        
        mainViewModel.dailyForecasts
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: nextWeekForecastView.forecasts)
            .disposed(by: disposeBag)
    }
    
    @objc func menuAction(sender: UIButton) {
        
    }

    @objc func searchAction(sender: UIButton) {
        
    }
}

extension MainView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }
}
