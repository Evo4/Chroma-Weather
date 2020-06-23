//
//  CurentWeatherView.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 19.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WeatherInfoView: UIView {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "opened weather card")
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.7
        return imageView
    }()
    
    private lazy var forecastInfoScrollView: CommonForecastInfoScrollView = {
        let scrollView = CommonForecastInfoScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var forecastIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var hourlyForecastView: HourlyForecastView = {
        let view = HourlyForecastView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let disposeBag = DisposeBag()
    let currentForecast = PublishSubject<Forecast>()
    let hourlyForecasts = PublishSubject<[HourlyForecast]>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.3647058824, green: 0.3137254902, blue: 0.9960784314, alpha: 1)
        self.layer.cornerRadius = 39
        self.clipsToBounds = true
        
        setupConstraints()
        
        currentForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                return $0.weather[0].icon
            }.subscribe(onNext: { [weak self] iconName in
                APIProvider.shared.loadForecastIcon(iconName: iconName) { (result) in
                    switch result {
                    case .success(let data):
                        self?.forecastIconImageView.image = UIImage(data: data)
                        break
                    case .failure(()):
                        break
                    }
                }
            }).disposed(by: disposeBag)
        
        hourlyForecasts.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: hourlyForecastView.hourlyForecasts.asObserver())
            .disposed(by: disposeBag)
        
        currentForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: forecastInfoScrollView.currentForecast)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupConstraints() {
        [backgroundImageView, forecastInfoScrollView, forecastIconImageView, hourlyForecastView].forEach { (subview) in
            self.addSubview(subview)
        }
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            forecastInfoScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            forecastInfoScrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            forecastInfoScrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
            forecastInfoScrollView.bottomAnchor.constraint(equalTo: hourlyForecastView.topAnchor, constant: -5),
            
            forecastIconImageView.heightAnchor.constraint(equalToConstant: 100),
            forecastIconImageView.widthAnchor.constraint(equalTo: forecastIconImageView.heightAnchor),
            forecastIconImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            forecastIconImageView.topAnchor.constraint(equalTo: self.topAnchor),
            
            hourlyForecastView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            hourlyForecastView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            hourlyForecastView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            hourlyForecastView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
}
