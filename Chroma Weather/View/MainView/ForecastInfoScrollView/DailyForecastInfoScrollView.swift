//
//  DailyForecastInfoScrollView.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 23.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import WeatherAPIKit

class DailyForecastInfoScrollView: ForecastInfoScrollView {

    let disposeBag = DisposeBag()
    let forecast = PublishSubject<DailyForecast>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isDayLabelHidden = false
        
        configureLabels()
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func configureLabels() {
        let color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
        minTemperatureLabel.textColor = color
        humidityValueLabel.textColor = color
        sunsetValueLabel.textColor = color
        sunriseValueLabel.textColor = color
        windValueLabel.textColor = color
        feelsLikeValueLabel.textColor = color
        pressureValueLabel.textColor = color
    }
    
    fileprivate func setupObservers() {
        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                let date = Date(timeIntervalSince1970: TimeInterval($0.dt))
                return date.toString(style: .weekday)
            }.bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                return $0.weather[0].icon
            }.subscribe(onNext: { [weak self] iconName in
                APIProvider.shared.loadForecastIcon(iconName: iconName) { (result) in
                    switch result {
                    case .success(let data):
                        self?.iconImageView.image = UIImage(data: data)
                        break
                    case .failure(()):
                        break
                    }
                }
            }).disposed(by: disposeBag)
        
        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                let temp = $0.temp ?? Temp()
                return temp.day.toCelsius()
            }.bind(to: currentTemperatureLabel.rx.text)
            .disposed(by: disposeBag)

        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                return $0.weather[0].weatherDescription.capitalizingFirstLetter()
            }.bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
//
        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                let temp = $0.temp ?? Temp()
                return temp.min.toCelsius()
            }.bind(to: minTemperatureLabel.rx.text)
            .disposed(by: disposeBag)

        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                let temp = $0.temp ?? Temp()
                return temp.max.toCelsius()
            }.bind(to: maxTemperatureLabel.rx.text)
            .disposed(by: disposeBag)

        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                return "\($0.humidity)%"
            }.bind(to: humidityValueLabel.rx.text)
            .disposed(by: disposeBag)

        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map { forecast -> String in
                let date = Date(timeIntervalSince1970: TimeInterval(forecast.sunrise))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: date)
            }.bind(to: sunriseValueLabel.rx.text)
            .disposed(by: disposeBag)

        forecast.asObservable()
        .observeOn(MainScheduler.instance)
        .map { forecast -> String in
            let date = Date(timeIntervalSince1970: TimeInterval(forecast.sunset))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }.bind(to: sunsetValueLabel.rx.text)
        .disposed(by: disposeBag)

        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                return "\($0.windSpeed) km/hr"
            }.bind(to: windValueLabel.rx.text)
            .disposed(by: disposeBag)

        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                let feelsLike = $0.feelsLike ?? FeelsLike()
                return feelsLike.day.toCelsius()
            }.bind(to: feelsLikeValueLabel.rx.text)
            .disposed(by: disposeBag)

        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                return "\($0.pressure) hPa"
            }.bind(to: pressureValueLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
