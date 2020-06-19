//
//  CurentWeatherView.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 19.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit

class CurrentWeatherView: UIView {
    
    private lazy var currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Regular", size: 120)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView1: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.currentTemperatureLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.3647058824, green: 0.3137254902, blue: 0.9960784314, alpha: 1)
        self.layer.cornerRadius = 39
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupConstraints() {
        [stackView1].forEach { (subview) in
            self.addSubview(subview)
        }
        NSLayoutConstraint.activate([
            stackView1.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView1.topAnchor.constraint(equalTo: self.topAnchor, constant: 50)
        ])
    }
}
