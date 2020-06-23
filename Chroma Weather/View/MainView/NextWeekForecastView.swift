//
//  NextWeekForecastView.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 23.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NextWeekForecastView: UIView {
    
    private lazy var forecastCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: SnapPagingLayout(centerPosition: true, peekWidth: 80, spacing: 50, inset: 75))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let forecasts = PublishSubject<[DailyForecast]>()
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        setupConstraints()
        
        forecastCollectionView.register(NextWeekForecastCell.self, forCellWithReuseIdentifier: "cell")
        forecastCollectionView.delegate = self
        
        forecasts.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: forecastCollectionView.rx.items(cellIdentifier: "cell", cellType: NextWeekForecastCell.self)) { index, forecast, cell in
                cell.forecast.onNext(forecast)
            }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupConstraints() {
        self.addSubview(forecastCollectionView)
        NSLayoutConstraint.activate([
            forecastCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            forecastCollectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            forecastCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            forecastCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            forecastCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6)
        ])
    }
}

extension NextWeekForecastView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let layout = forecastCollectionView.collectionViewLayout as? SnapPagingLayout else { return }
        layout.willBeginDragging()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = forecastCollectionView.collectionViewLayout as? SnapPagingLayout else { return }
        layout.willEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
