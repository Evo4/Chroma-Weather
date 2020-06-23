//
//  ForecastInfoScrollView.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 23.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ForecastInfoScrollView: UIScrollView {

    private lazy var newView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont(name: "OpenSans-Bold", size: 47)
        label.textAlignment = .center
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Regular", size: 120)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    var currentTemperatureLabelTopAnchorToView: NSLayoutConstraint!
    var currentTemperatureLabelTopAnchorToIcon: NSLayoutConstraint!
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Regular", size: 23)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    lazy var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 27)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    lazy var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 27)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    // MARK: - humidity
    private lazy var humidityHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 19)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.text = "Humidity"
        return label
    }()
    
    lazy var humidityValueLabel: UILabel = {
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
    
    // MARK: - sunrise
    private lazy var sunriseHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 19)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.text = "Sunrise"
        return label
    }()
    
    lazy var sunriseValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 27)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)
        return label
    }()
    
    private lazy var sunriseStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.sunriseHeaderLabel, self.sunriseValueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - sunset
    private lazy var sunsetHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 19)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.text = "Sunset"
        return label
    }()
    
    lazy var sunsetValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 27)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)
        return label
    }()
    
    private lazy var sunsetStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.sunsetHeaderLabel, self.sunsetValueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - wind
    private lazy var windHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 19)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.text = "Wind"
        return label
    }()
    
    lazy var windValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 27)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)
        return label
    }()
    
    private lazy var windStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.windHeaderLabel, self.windValueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - feels like
    private lazy var feelsLikeHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 19)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.text = "Feels Like"
        return label
    }()
    
    lazy var feelsLikeValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 27)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)
        return label
    }()
    
    private lazy var feelsLikeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.feelsLikeHeaderLabel, self.feelsLikeValueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - pressure
    private lazy var pressureHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 19)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.text = "Pressure"
        return label
    }()
    
    lazy var pressureValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 27)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)
        return label
    }()
    
    private lazy var pressureStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.pressureHeaderLabel, self.pressureValueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    var isDayLabelHidden = true {
        didSet {
            if isDayLabelHidden {
                dayLabel.alpha = 0
                iconImageView.alpha = 0
                currentTemperatureLabelTopAnchorToView.isActive = true
                currentTemperatureLabelTopAnchorToIcon.isActive = false
            } else {
                dayLabel.alpha = 1
                iconImageView.alpha = 1
                currentTemperatureLabelTopAnchorToView.isActive = false
                currentTemperatureLabelTopAnchorToIcon.isActive = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        
        setupConstraints()
        isDayLabelHidden = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    fileprivate func setupConstraints() {
        self.addSubview(newView)
        [dayLabel, iconImageView, currentTemperatureLabel, minTemperatureLabel, maxTemperatureLabel, descriptionLabel, humidityStackView, sunriseStackView, sunsetStackView, windStackView, feelsLikeStackView, pressureStackView].forEach { (subview) in
            newView.addSubview(subview)
        }
        
        currentTemperatureLabelTopAnchorToView = currentTemperatureLabel.topAnchor.constraint(equalTo: newView.topAnchor)
        currentTemperatureLabelTopAnchorToIcon = currentTemperatureLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: -15)
        NSLayoutConstraint.activate([
            newView.topAnchor.constraint(equalTo: self.topAnchor),
            newView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            newView.leftAnchor.constraint(equalTo: self.leftAnchor),
            newView.rightAnchor.constraint(equalTo: self.rightAnchor),
            newView.widthAnchor.constraint(equalTo: self.widthAnchor),
            newView.heightAnchor.constraint(lessThanOrEqualToConstant: 1000),
            
            dayLabel.centerXAnchor.constraint(equalTo: newView.centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: newView.topAnchor),
            
            iconImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: newView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 20),
            
            currentTemperatureLabel.centerXAnchor.constraint(equalTo: newView.centerXAnchor, constant: 20),
            currentTemperatureLabelTopAnchorToView,
            
            minTemperatureLabel.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor, constant: -30),
            minTemperatureLabel.centerXAnchor.constraint(equalTo: newView.centerXAnchor, constant: -70),
            
            maxTemperatureLabel.topAnchor.constraint(equalTo: minTemperatureLabel.topAnchor),
            maxTemperatureLabel.centerXAnchor.constraint(equalTo: newView.centerXAnchor, constant: 70),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: newView.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: minTemperatureLabel.bottomAnchor, constant: 0),
            
            humidityStackView.centerXAnchor.constraint(equalTo: newView.centerXAnchor),
            humidityStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            
            sunriseStackView.centerXAnchor.constraint(equalTo: newView.centerXAnchor),
            sunriseStackView.topAnchor.constraint(equalTo: humidityStackView.bottomAnchor, constant: 15),
            
            sunsetStackView.centerXAnchor.constraint(equalTo: newView.centerXAnchor),
            sunsetStackView.topAnchor.constraint(equalTo: sunriseStackView.bottomAnchor, constant: 15),
            
            windStackView.centerXAnchor.constraint(equalTo: newView.centerXAnchor),
            windStackView.topAnchor.constraint(equalTo: sunsetStackView.bottomAnchor, constant: 15),
            
            feelsLikeStackView.centerXAnchor.constraint(equalTo: newView.centerXAnchor),
            feelsLikeStackView.topAnchor.constraint(equalTo: windStackView.bottomAnchor, constant: 15),
            
            pressureStackView.centerXAnchor.constraint(equalTo: newView.centerXAnchor),
            pressureStackView.topAnchor.constraint(equalTo: feelsLikeStackView.bottomAnchor, constant: 15),
            
            newView.bottomAnchor.constraint(equalTo: pressureStackView.bottomAnchor, constant: 15),
        ])
    }
}
