//
//  TodayViewModel.swift
//  Chroma Weather Widget
//
//  Created by Vyacheslav on 01.07.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation
import WeatherAPIKit
import RxCocoa
import RxSwift
import CoreLocation
import RxCoreLocation
import RealmSwift
import RxRealm

class TodayViewModel {
    let location = PublishSubject<CLLocation>()
    
    var forecast: Observable<Forecast> {
        return getForecast()
    }
    
    var locationName: Observable<String> {
        return getLocationName()
    }
    
    var description: Observable<String> {
        return getDescription()
    }
    
    var weatherIcon: Observable<Data> {
        return getWeatherIcon()
    }
    
    var currentTemperature: Observable<String> {
        return getCurrentTemperature()
    }
    
    var maxTemperature: Observable<String> {
        return getMaxTemperature()
    }
    
    var minTemperature: Observable<String> {
        return getMinTemperature()
    }
    
    fileprivate func getForecast()-> Observable<Forecast> {
        return Observable.create { [weak self] observable -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            self?.location
                .asObservable()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { location in
                    APIProvider.shared.getCurrentForecast(location: location) { (result) in
                        switch result {
                        case .success(let forecast):
                            observable.onNext(forecast)
                            break
                        case .failure(()):
                            break
                        }
                    }
                }).disposed(by: disposeBag)
            return Disposables.create {
                disposeBag = nil
            }
        }
    }
    
    fileprivate func getDescription()->Observable<String> {
        return Observable.create { [weak self] (observable) -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            self?.forecast
                .observeOn(MainScheduler.instance)
                .map {
                    return $0.weather[0].weatherDescription.capitalizingFirstLetter()
            }.subscribe(onNext: { description in
                observable.onNext(description)
                }).disposed(by: disposeBag)
            return Disposables.create {
                disposeBag = nil
            }
        }
    }
    
    fileprivate func getWeatherIcon()->Observable<Data> {
        return Observable.create { [weak self] (observable) -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            self?.forecast
                .observeOn(MainScheduler.instance)
                .map {
                    return $0.weather[0].icon
                }.subscribe(onNext: { iconName in
                    APIProvider.shared.loadForecastIcon(iconName: iconName) { (result) in
                        switch result {
                        case .success(let data):
                            observable.onNext(data)
                            break
                        case .failure(()):
                            break
                        }
                    }
                }).disposed(by: disposeBag)
            return Disposables.create {
                disposeBag = nil
            }
        }
    }
    
    fileprivate func getCurrentTemperature()->Observable<String> {
        return Observable.create { [weak self] (observable) -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            self?.forecast
                .observeOn(MainScheduler.instance)
                .map {
                    return $0.main?.temp.toCelsius()
                }.subscribe(onNext: { temp in
                    guard let temp = temp else {return}
                observable.onNext(temp)
                }).disposed(by: disposeBag)
            return Disposables.create {
                disposeBag = nil
            }
        }
    }
    
    fileprivate func getMaxTemperature()->Observable<String> {
        return Observable.create { [weak self] (observable) -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            self?.forecast
                .observeOn(MainScheduler.instance)
                .map {
                    return $0.main?.tempMax.toCelsius()
                }.subscribe(onNext: { temp in
                guard let temp = temp else {return}
                observable.onNext(temp)
                }).disposed(by: disposeBag)
            return Disposables.create {
                disposeBag = nil
            }
        }
    }
    
    fileprivate func getMinTemperature()->Observable<String> {
        return Observable.create { [weak self] (observable) -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            self?.forecast
                .observeOn(MainScheduler.instance)
                .map {
                    return $0.main?.tempMin.toCelsius()
                }.subscribe(onNext: { temp in
                guard let temp = temp else {return}
                observable.onNext(temp)
                }).disposed(by: disposeBag)
            return Disposables.create {
                disposeBag = nil
            }
        }
    }

    
    fileprivate func getLocationName()->Observable<String> {
        return Observable.create { [weak self] (observable) -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            self?.location
                .asObservable()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (location) in
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location) { (placemarks, _) in
                    placemarks?.forEach({ (placemark) in
                        if let city = placemark.locality {
                            let locationName = city
                            Settings.shared.serializeLocationName(of: locationName)
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
}
