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
    
    let currentForecast = PublishSubject<Forecast>()
    let oneCallForecast = PublishSubject<OneCallForecast>()

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
    
    private func getTommorowForecast()->Observable<Forecast> {
        return Observable.create { [weak self] (observable) -> Disposable in
            var disposeBag: DisposeBag! = DisposeBag()
            self?.oneCallForecast.asObservable().subscribe(onNext: { (forecast) in
                var newForecast: Forecast?
                forecast.daily.forEach { (dailyForecast) in
                    let date = Date(timeIntervalSince1970: TimeInterval(dailyForecast.dt))
                    if date.isTomorrow() {
                        newForecast = Forecast(coord: Coord(lon: 0, lat: 0), weather: dailyForecast.weather, base: "", main: Stats(temp: dailyForecast.temp.day, feelsLike: dailyForecast.feelsLike.day, tempMin: dailyForecast.temp.min, tempMax: dailyForecast.temp.max, pressure: dailyForecast.pressure, humidity: dailyForecast.humidity), visibility: 0, wind: Wind(speed: dailyForecast.windSpeed, deg: dailyForecast.windDeg), clouds: Clouds(all: dailyForecast.clouds), dt: dailyForecast.dt, sys: Sys(type: 0, id: 0, country: "", sunrise: dailyForecast.sunrise, sunset: dailyForecast.sunset), timezone: 0, id: 0, name: "", cod: 0)
                    }
                }
                forecast.hourly.forEach { (hourlyForecast) in
                    guard let forecast = newForecast else {return}
                    let date1 = Date(timeIntervalSince1970: TimeInterval(hourlyForecast.dt))
                    let date2 = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
                    if date1.isDay(of: date2) {
                        newForecast?.hourlyForecast?.append(hourlyForecast)
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
    
}
