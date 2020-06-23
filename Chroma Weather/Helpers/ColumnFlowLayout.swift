//
//  CustomCollectionViewLayout.swift
//  E-shop
//
//  Created by Vyacheslav on 30.01.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {

    let cellsPerRow: Int
    let cellHeightMultiplier: CGFloat
    let cellHeight: CGFloat

    init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        self.cellHeightMultiplier = 0.0
        self.cellHeight = 0.0
        super.init()

        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }
    
    init(cellsPerRow: Int, cellHeightMultiplier: CGFloat, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        self.cellHeightMultiplier = cellHeightMultiplier
        self.cellHeight = 0.0
        super.init()

        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }
    
    init(cellsPerRow: Int, cellHeight: CGFloat = 0.0, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        self.cellHeightMultiplier = 0.0
        self.cellHeight = cellHeight
        super.init()

        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        
        if cellHeightMultiplier == 0 && cellHeight == 0 {
            itemSize = CGSize(width: itemWidth, height: itemWidth)
        } else if cellHeight != 0 {
            itemSize = CGSize(width: itemWidth, height: cellHeight)
        } else {
            itemSize = CGSize(width: itemWidth, height: itemWidth * cellHeightMultiplier)
        }        
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

}
