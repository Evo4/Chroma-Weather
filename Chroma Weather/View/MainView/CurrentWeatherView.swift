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

class CurrentWeatherView: UIView {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "opened weather card")
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.7
        return imageView
    }()
    
    private lazy var currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Regular", size: 120)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Regular", size: 23)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    private lazy var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 27)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 27)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var humidityHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 19)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.text = "Humidity"
        return label
    }()
    
    private lazy var humidityValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 27)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)
        return label
    }()
    
    private lazy var humidityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.humidityHeaderLabel, self.humidityValueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var forecastIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let disposeBag = DisposeBag()
    let currentForecast = PublishSubject<CurrentForecast>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.3647058824, green: 0.3137254902, blue: 0.9960784314, alpha: 1)
        self.layer.cornerRadius = 39
        self.clipsToBounds = true
        
        setupConstraints()
        
        currentForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                return $0.main.temp.toCelsius()
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
                return $0.main.tempMin.toCelsius()
            }.bind(to: minTemperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        currentForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                return $0.main.tempMax.toCelsius()
            }.bind(to: maxTemperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        currentForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                return "\($0.main.humidity)%"
            }.bind(to: humidityValueLabel.rx.text)
            .disposed(by: disposeBag)
        
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupConstraints() {
        [backgroundImageView, currentTemperatureLabel, minTemperatureLabel, maxTemperatureLabel, descriptionLabel, humidityStackView, forecastIconImageView].forEach { (subview) in
            self.addSubview(subview)
        }
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            currentTemperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 20),
            currentTemperatureLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            minTemperatureLabel.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor, constant: -30),
            minTemperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -70),
            
            maxTemperatureLabel.topAnchor.constraint(equalTo: minTemperatureLabel.topAnchor),
            maxTemperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 70),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: minTemperatureLabel.bottomAnchor, constant: 0),
            
            humidityStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            humidityStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            
//            self.bottomAnchor.constraint(equalTo: humidityStackView.bottomAnchor, constant: 20),
            
            forecastIconImageView.heightAnchor.constraint(equalToConstant: 100),
            forecastIconImageView.widthAnchor.constraint(equalTo: forecastIconImageView.heightAnchor),
            forecastIconImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            forecastIconImageView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
}
