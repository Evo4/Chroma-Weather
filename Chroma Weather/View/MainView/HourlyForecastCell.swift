//
//  HourlyForecastCell.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 22.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import WeatherAPIKit

class HourlyForecastCell: UICollectionViewCell {
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "OpenSans-Regular", size: 19)
        return label
    }()
    
    let hourlyForecast = PublishSubject<HourlyForecast>()
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        setupConstraints()
        
        hourlyForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map { (forecast) -> String in
                let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: date)
            }.bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        hourlyForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                return $0.temp.toCelsius()
            }.bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        hourlyForecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                return $0.weather[0].icon
            }.subscribe(onNext: { [weak self] (iconName) in
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupConstraints() {
        [timeLabel, iconImageView, temperatureLabel].forEach { (subview) in
            self.addSubview(subview)
        }
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
