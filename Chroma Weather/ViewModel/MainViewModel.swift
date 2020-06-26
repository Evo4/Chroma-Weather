//
//  MainViewModel.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 19.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import RxCoreLocation
import AFDateHelper
import RxRealm
import RealmSwift

class MainViewModel {
    let locationManager = CLLocationManager()
    
    let location = PublishSubject<CLLocation>()
    
    let currentForecast = PublishSubject<Forecast>()
    let oneCallForecast = PublishSubject<OneCallForecast>()
    
    let realm = try! Realm()
    
    var realmLocations: Results<RealmLocation> {
        return self.realm.objects(RealmLocation.self)
    }
    
    var tomorrowForecast: Observable<Forecast> {
        return getTommorowForecast()
    }
    
    var todayHourlyForecast: Observable<[HourlyForecast]> {
        return getTodayHourlyForecast()
    }
    
    var dailyForecasts: Observable<[DailyForecast]> {
        return getDailyForecasts()
    }
    
    let forecastTypes = PublishSubject<[ForecastType]>()
    
    func getLocationName()->Observable<String> {
        return Observable.create { [weak self] (observable) -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            let location = CLLocation(latitude: self!.realmLocations[0].latitude, longitude: self!.realmLocations[0].longitude)
            self?.location
                .asObservable()
                .startWith(location)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (location) in
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location) { (placemarks, _) in
                    placemarks?.forEach({ (placemark) in
                        if let city = placemark.locality, let country = placemark.country {
                            let locationName = "\(city), \(country)"
//                            Settings.shared.serializeLocationName(of: locationName)
                            observable.onNext(locationName)
                        }
                    })
                }
                }).disposed(by: disposeBag)
            return Disposables.create {
                disposeBag = nil
            }
        }
    }
    
    private func getTommorowForecast()->Observable<Forecast> {
        return Observable.create { [weak self] (observable) -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            self?.oneCallForecast.asObservable().subscribe(onNext: { (forecast) in
                var newForecast: Forecast?
                forecast.daily.forEach { (dailyForecast) in
                    let date = Date(timeIntervalSince1970: TimeInterval(dailyForecast.dt))
                    if date.isTomorrow() {
                        newForecast = Forecast(value: [Coord(value: [0,0]),
                                                       dailyForecast.weather,
                                                       "",
                                                       Stats(value: [dailyForecast.temp?.day ?? Temp().day,
                                                                     dailyForecast.feelsLike?.day ?? FeelsLike().day,
                                                                     dailyForecast.temp?.min ?? Temp().min,
                                                                     dailyForecast.temp?.max ?? Temp().max,
                                                                     dailyForecast.pressure,
                                                                     dailyForecast.humidity]),
                                                       0,
                                                       Wind(value: [dailyForecast.windSpeed,
                                                            dailyForecast.windDeg]),
                                                       Clouds(value: [dailyForecast.clouds]),
                                                       dailyForecast.dt,
                                                       Sys(value: [0, 0, "", dailyForecast.sunrise, dailyForecast.sunset]),
                                                       0,
                                                       0,
                                                       "",
                                                       0])
                    }
                }
                forecast.hourly.forEach { (hourlyForecast) in
                    guard let forecast = newForecast else {return}
                    let date1 = Date(timeIntervalSince1970: TimeInterval(hourlyForecast.dt))
                    let date2 = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
                    if date1.isDay(of: date2) {
                        newForecast?.hourlyForecast.append(hourlyForecast)
                    }
                }
                if let forecast = newForecast {
                    observable.onNext(forecast)
                }
                }).disposed(by: disposeBag)
            return Disposables.create {
                disposeBag = nil
            }
        }
    }
    
    private func getTodayHourlyForecast()-> Observable<[HourlyForecast]> {
        return Observable.create { [weak self] (observer) -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            self?.oneCallForecast
                .asObservable()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (forecast) in
                    var hourlyForecastArr: [HourlyForecast] = []
                    forecast.hourly.forEach { (hourlyForecast) in
                        let date = Date(timeIntervalSince1970: TimeInterval(hourlyForecast.dt))
                        if date.isToday() && date.isNextHour() {
                            hourlyForecastArr.append(hourlyForecast)
                        }
                    }
                    observer.onNext(hourlyForecastArr)
                }).disposed(by: disposeBag)
            return Disposables.create {
                disposeBag = nil
            }
        }
    }
    
    private func getDailyForecasts()-> Observable<[DailyForecast]> {
        return Observable.create { [weak self] (observer) -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            self?.oneCallForecast
                .asObservable()
                .map {
                    return $0.daily
                }.subscribe(onNext: { (dailyForecasts) in
                    var forecasts: [DailyForecast] = []
                    dailyForecasts.forEach { (forecast) in
                        let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
                        if !date.isToday() {
                            forecasts.append(forecast)
                        }
                    }
                    observer.onNext(forecasts)
                }).disposed(by: disposeBag)
            return Disposables.create {
                disposeBag = nil
            }
        }
    }
    
    func configureLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func configureLocation(status: CLAuthorizationStatus, completion: @escaping (()->())) {
        var location: CLLocation?
        switch status {
        case .denied:
            location = locationManager.location
        case .notDetermined:
            location = locationManager.location
        case .restricted:
            location = locationManager.location
        case .authorizedAlways, .authorizedWhenInUse:
            location = locationManager.location
        @unknown default:
            break
        }
        if self.realmLocations.count == 0 {
            let location = location ?? CLLocation(latitude: 50.432275, longitude: 30.541816)
            let realmLocation = RealmLocation()
            realmLocation.latitude = location.coordinate.latitude
            realmLocation.longitude = location.coordinate.longitude

            try! self.realm.write {
                self.realm.add(realmLocation)
            }
        }
        completion()
    }
}
