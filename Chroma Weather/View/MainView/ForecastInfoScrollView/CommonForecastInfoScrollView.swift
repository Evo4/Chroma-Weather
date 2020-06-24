//
//  CommonForecastInfoScrollView.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 23.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CommonForecastInfoScrollView: ForecastInfoScrollView {

    let disposeBag = DisposeBag()
    let currentForecast = PublishSubject<Forecast>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupObservers() {
        currentForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                let main = $0.main ?? Stats()
                return main.temp.toCelsius()
            }.bind(to: currentTemperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        currentForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                return $0.weather[0].weatherDescription.capitalizingFirstLetter()
            }.bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        currentForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                let main = $0.main ?? Stats()
                return main.tempMin.toCelsius()
            }.bind(to: minTemperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        currentForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                let main = $0.main ?? Stats()
                return main.tempMax.toCelsius()
            }.bind(to: maxTemperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        currentForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                let main = $0.main ?? Stats()
                return "\(main.humidity)%"
            }.bind(to: humidityValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        currentForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map { forecast -> String in
                let sys = forecast.sys ?? Sys()
                let date = Date(timeIntervalSince1970: TimeInterval(sys.sunrise))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: date)
            }.bind(to: sunriseValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        currentForecast.asObservable()
        .observeOn(MainScheduler.instance)
        .map { forecast -> String in
            let sys = forecast.sys ?? Sys()
            let date = Date(timeIntervalSince1970: TimeInterval(sys.sunset))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }.bind(to: sunsetValueLabel.rx.text)
        .disposed(by: disposeBag)
        
        currentForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                let wind = $0.wind ?? Wind()
                return "\(wind.speed) km/hr"
            }.bind(to: windValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        currentForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                let main = $0.main ?? Stats()
                return main.feelsLike.toCelsius()
            }.bind(to: feelsLikeValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        currentForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                let main = $0.main ?? Stats()
                return "\(main.pressure) hPa"
            }.bind(to: pressureValueLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
