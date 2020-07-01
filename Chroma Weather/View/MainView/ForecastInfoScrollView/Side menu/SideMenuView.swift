//
//  SideMenuView.swift
//  E-shop
//
//  Created by Vyacheslav on 31.01.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import WeatherAPIKit

class SideMenuView: UIView {

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "Hom Screen")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.35)
        return view
    }()
    
    lazy var menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return tableView
    }()
    
    let items = PublishSubject<[SideMenuItem]>()
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        setupConstraints()
        
        items.asObservable()
            .startWith([
            SideMenuItem(image: #imageLiteral(resourceName: "map"), text: "Search on map"),
            SideMenuItem(image: #imageLiteral(resourceName: "exit.png"), text: "Exit")
            ])
            .bind(to: menuTableView.rx.items(cellIdentifier: "cell", cellType: SideMenuCell.self)) { index, item, cell in
                cell.item.onNext(item)
                cell.index = index
            }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupAppearance() {
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        menuTableView.register(SideMenuCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupConstraints() {
        [logoImageView, menuTableView, separatorView].forEach { (subview) in
            self.addSubview(subview)
        }
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            logoImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            logoImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            menuTableView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            menuTableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            menuTableView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            separatorView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            separatorView.widthAnchor.constraint(equalTo: self.widthAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
}
