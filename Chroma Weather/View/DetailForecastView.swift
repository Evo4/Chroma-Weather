//
//  DetailForecastView.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 23.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import WeatherAPIKit

class DetailForecastView: UIViewController {

    private lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        view.roundCorners(corners: [.topLeft, .topRight], radius: 55)
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.25
        button.layer.cornerRadius = 26
        button.addTarget(self, action: #selector(closeViewAction(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var forecastInfoScrollView: DailyForecastInfoScrollView = {
        let scrollView = DailyForecastInfoScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let forecast = PublishSubject<DailyForecast>()
    let disposeBag = DisposeBag()
    var dailyForecast: DailyForecast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setupConstraints()
        
        guard let dailyForecast = self.dailyForecast else {return}
        forecast.asObservable()
            .startWith(dailyForecast)
            .observeOn(MainScheduler.instance)
            .bind(to: forecastInfoScrollView.forecast.asObserver())
            .disposed(by: disposeBag)
        
        forecast.asObservable()
            .startWith(dailyForecast)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (forecast) in
                let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
                let day = date.toString(style: .weekday)
                let color = UIColor.getDayColor(day: day)
                self?.backView.setGradientBackground(color1: color.lighter(by: 20)!, color2: color, width: self!.view.frame.size.width, height: self!.view.frame.size.height * 0.88)
            }).disposed(by: disposeBag)

    }
    
    fileprivate func setupConstraints() {
        view.addSubview(backView)
        view.addSubview(closeButton)
        backView.addSubview(forecastInfoScrollView)
        
        let closeImageView = UIImageView()
        closeImageView.translatesAutoresizingMaskIntoConstraints = false
        closeImageView.image = #imageLiteral(resourceName: "close")
        closeImageView.contentMode = .scaleAspectFit
        closeButton.addSubview(closeImageView)
        
        NSLayoutConstraint.activate([
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.88),
            
            closeButton.widthAnchor.constraint(equalToConstant: 52),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            closeButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            closeButton.centerYAnchor.constraint(equalTo: backView.topAnchor),
            
            closeImageView.widthAnchor.constraint(equalToConstant: 12),
            closeImageView.heightAnchor.constraint(equalTo: closeImageView.widthAnchor),
            closeImageView.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            closeImageView.centerXAnchor.constraint(equalTo: closeButton.centerXAnchor),
            
            forecastInfoScrollView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            forecastInfoScrollView.leftAnchor.constraint(equalTo: backView.leftAnchor),
            forecastInfoScrollView.rightAnchor.constraint(equalTo: backView.rightAnchor),
            forecastInfoScrollView.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
        ])
    }
    
    @objc fileprivate func closeViewAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
