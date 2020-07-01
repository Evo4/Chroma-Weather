//
//  HourlyForecastView.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 22.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import WeatherAPIKit

class HourlyForecastView: UIView {

    private lazy var hourlyForecastCollectionView: UICollectionView = {
        let cellHeight: CGFloat = 110 * 0.7
        let layout = ColumnFlowLayout(cellsPerRow: 5, cellHeight: cellHeight, minimumInteritemSpacing: 0, minimumLineSpacing: 0, sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let hourlyForecasts = PublishSubject<[HourlyForecast]>()
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.cornerRadius = 39
        self.clipsToBounds = true
        
        setupConstraints()
        setupCollectionView()
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupConstraints() {
        self.addSubview(hourlyForecastCollectionView)
        NSLayoutConstraint.activate([
            hourlyForecastCollectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            hourlyForecastCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hourlyForecastCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            hourlyForecastCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        ])
    }
    
    fileprivate func setupCollectionView() {
        hourlyForecastCollectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: "cell")
        
        hourlyForecasts.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: hourlyForecastCollectionView.rx.items(cellIdentifier: "cell", cellType: HourlyForecastCell.self)) { index, forecast, cell in
                cell.hourlyForecast.onNext(forecast)
        }.disposed(by: disposeBag)
    }
}
