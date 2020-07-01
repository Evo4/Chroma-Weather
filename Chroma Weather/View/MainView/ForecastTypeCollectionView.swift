//
//  ForecastTypeCollectionView.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 19.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import WeatherAPIKit

class ForecastTypeCollectionView: UICollectionView {
    
    let forecastTypes = PublishSubject<[ForecastType]>()
    private let dispodeBag = DisposeBag()
    
    private var selectedType: Int = 0 {
        didSet {
            self.reloadData()
        }
    }
    
    var forecastTypeCallback: ((Int)->())?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupCollectionView() {
        self.backgroundColor = .clear
        
        self.register(ForecastTypeCell.self, forCellWithReuseIdentifier: "cell")
        
     forecastTypes.asObservable()
         .observeOn(MainScheduler.instance)
         .bind(to: self.rx.items(cellIdentifier: "cell", cellType: ForecastTypeCell.self)) { [weak self] index, forecast, cell in
             cell.forecastType = forecast
             cell.selectedCallback = { [weak self] in
                self?.selectedType = index
                self?.forecastTypeCallback?(index)
             }
             
             if self?.selectedType == index {
                 cell.isSelected = true
                 cell.isChoosed = true
             } else {
                 cell.isSelected = false
                 cell.isChoosed = false
             }
            }.disposed(by: dispodeBag)
    }
}

