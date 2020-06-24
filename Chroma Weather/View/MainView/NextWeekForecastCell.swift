//
//  NextWeekForecastCell.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 23.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NextWeekForecastCell: UICollectionViewCell {
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont(name: "OpenSans-Bold", size: 24)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var dayTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont(name: "OpenSans-Regular", size: 47)
        return label
    }()
    
    private lazy var stackView1: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.iconImageView, self.dayTemperatureLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
        label.font = UIFont(name: "OpenSans-Bold", size: 23)
        return label
    }()
    
    private lazy var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont(name: "OpenSans-Bold", size: 23)
        return label
    }()
    
    private lazy var stackView2: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.minTemperatureLabel, self.maxTemperatureLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 40
        return stackView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forecast = PublishSubject<DailyForecast>()
    let disposeBag = DisposeBag()
    var dailyForecast: DailyForecast?
    
    var detailForecastCallback: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 36
        self.clipsToBounds = true
        self.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        setupConstraints()
        
        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                let date = Date(timeIntervalSince1970: TimeInterval($0.dt))
                return date.toString(style: .weekday)
            }.bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map { return $0.weather[0].icon
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
        
        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .map {
                return $0.temp.day.toCelsius()
            }.bind(to: dayTemperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        forecast.asObservable()
        .observeOn(MainScheduler.instance)
        .map {
            return $0.temp.min.toCelsius()
        }.bind(to: minTemperatureLabel.rx.text)
        .disposed(by: disposeBag)
        
        forecast.asObservable()
        .observeOn(MainScheduler.instance)
        .map {
            return $0.temp.max.toCelsius()
        }.bind(to: maxTemperatureLabel.rx.text)
        .disposed(by: disposeBag)
        
        forecast.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { forecast in
                self.dailyForecast = forecast
            }).disposed(by: disposeBag)
        
        button.rx.tap
            .bind(onNext: { [weak self] in
                guard let rootController = UIApplication.shared.keyWindow?.rootViewController else {return}
                let detailView = DetailForecastView()
                detailView.dailyForecast = self?.dailyForecast
                rootController.present(detailView, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupConstraints() {
        [dayLabel, stackView1, stackView2, button].forEach { (subview) in
            self.addSubview(subview)
        }
        NSLayoutConstraint.activate([
            
            dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            
            stackView1.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView1.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            iconImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            
            stackView2.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView2.topAnchor.constraint(equalTo: stackView1.bottomAnchor, constant: 5),
            
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.leftAnchor.constraint(equalTo: self.leftAnchor),
            button.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
}
