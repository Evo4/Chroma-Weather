//
//  ForecastTypeCollectionView.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 19.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit

class ForecastTypeCollectionView: UICollectionView {
    
    private let forecastTypes: [ForecastType] = [
        ForecastType(type: .today),
        ForecastType(type: .tomorrow),
        ForecastType(type: .nextWeek),
    ]
    
    var selectedType: Int = 0 {
        didSet {
            self.reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupCollectionView() {
        self.backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
        
        self.register(ForecastTypeCell.self, forCellWithReuseIdentifier: "cell")
    }
}

extension ForecastTypeCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ForecastTypeCell {
            let forecastType = forecastTypes[indexPath.row]
            cell.forecastType = forecastType
            cell.selectedCallback = { [weak self] in
                self?.selectedType = indexPath.row
            }
            
            if selectedType == indexPath.row {
                cell.isChoosed = true
            } else {
                cell.isChoosed = false
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}
