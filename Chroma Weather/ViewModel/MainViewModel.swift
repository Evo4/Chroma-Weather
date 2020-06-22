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

class MainViewModel {
    let location = PublishSubject<CLLocation>()
    
    let currentForecast = PublishSubject<CurrentForecast>()
    let oneCallForecast = PublishSubject<OneCallForecast>()
//    let tomorrowForecats = PublishSubject<Daily>()
    var tomorrowForecast: Observable<Daily> {
        return getTommorowForecast()
    }
    
    let forecastTypes = PublishSubject<[ForecastType]>()
    
    func getLocationName()->Observable<String> {
        return Observable.create { (observable) -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            self.location.asObserver().subscribe(onNext: { (location) in
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location) { (placemarks, _) in
                    placemarks?.forEach({ (placemark) in
                        if let city = placemark.locality, let country = placemark.country {
                            let locationName = "\(city), \(country)"
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

    private func getTommorowForecast()->Observable<Daily> {
        return Observable.create { [weak self] (observable) -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            self?.oneCallForecast.asObservable().subscribe(onNext: { (forecast) in
                forecast.daily.forEach { (dailyForecast) in
                    let date = Date(timeIntervalSince1970: TimeInterval(dailyForecast.dt))
                    if date.isTomorrow() {
                        observable.onNext(dailyForecast)
                    }
                }
                }).disposed(by: disposeBag)
            return Disposables.create {
                disposeBag = nil
            }
        }
    }
}
