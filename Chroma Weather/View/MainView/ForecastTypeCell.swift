//
//  ForecastTypeCell.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 19.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import WeatherAPIKit

class ForecastTypeCell: UICollectionViewCell {
    
    private lazy var currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Bold", size: 15)
        label.textColor = #colorLiteral(red: 0.3650000095, green: 0.3140000105, blue: 0.9959999919, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    var forecastType: ForecastType? {
        didSet {
            guard let forecastType = self.forecastType else {return}
            currentTemperatureLabel.text = forecastType.type.rawValue
        }
    }
    
    var isChoosed: Bool = false {
        didSet {
            if isChoosed {
                currentTemperatureLabel.textColor = #colorLiteral(red: 0.3650000095, green: 0.3140000105, blue: 0.9959999919, alpha: 1)
                self.backgroundColor = #colorLiteral(red: 0.6784313725, green: 0.6549019608, blue: 0.9960784314, alpha: 0.1)
            } else {
                currentTemperatureLabel.textColor = #colorLiteral(red: 0.07500000298, green: 0.0549999997, blue: 0.3179999888, alpha: 1)
                self.backgroundColor = .clear
            }
        }
    }
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        setupConstraints()
    }
    
    var selectedCallback: (()->())?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupConstraints() {
        self.addSubview(currentTemperatureLabel)
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            currentTemperatureLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            currentTemperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.leftAnchor.constraint(equalTo: currentTemperatureLabel.leftAnchor, constant: -10),
            self.rightAnchor.constraint(equalTo: currentTemperatureLabel.rightAnchor, constant: 10),
            
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.leftAnchor.constraint(equalTo: self.leftAnchor),
            button.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    @objc func buttonAction(sender: UIButton) {
        selectedCallback?()
    }
}
