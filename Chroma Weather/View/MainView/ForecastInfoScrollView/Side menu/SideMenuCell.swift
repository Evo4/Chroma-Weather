//
//  SideMenuCell.swift
//  E-shop
//
//  Created by Vyacheslav on 31.01.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import FBSDKLoginKit
import GoogleSignIn
import FBSDKCoreKit

class SideMenuCell: UITableViewCell {

    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    private lazy var button: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let item = PublishSubject<SideMenuItem>()
    let disposeBag = DisposeBag()
    var index = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAppearance()
        setupConstraints()
        
        item.asObserver()
            .map {
                return $0.image
            }.bind(to: itemImageView.rx.image)
            .disposed(by: disposeBag)
        
        item.asObserver()
            .map {
                return $0.text
            }.bind(to: itemNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        button.rx
            .tap
            .subscribe(onNext: { [weak self] in
                if self?.index == 0 {
                    let mapView = MapView()
                    let navController = UINavigationController(rootViewController: mapView)
                    navController.modalPresentationStyle = .fullScreen
                    let rootViewController = UIApplication.shared.keyWindow?.rootViewController
                    rootViewController?.present(navController, animated: true, completion: nil)
                } else if self?.index == 1 {
                    if let googleAuth = GIDSignIn.sharedInstance()?.hasPreviousSignIn(), googleAuth {
                        GIDSignIn.sharedInstance()?.signOut()
                    } else if let _ = AccessToken.current {
                        LoginManager().logOut()
                    }
                    let signInView = SignInView()
                    signInView.modalPresentationStyle = .fullScreen
                    let rootViewController = UIApplication.shared.keyWindow?.rootViewController
                    UIApplication.shared.keyWindow?.rootViewController = signInView
                    rootViewController?.present(signInView, animated: true, completion: nil)
                    
                    Settings.shared.serializeUserIdToken(token: nil)
                }
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupAppearance() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    func setupConstraints() {
        [itemImageView, itemNameLabel, button].forEach { (subview) in
            self.addSubview(subview)
        }
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 50),
            
            itemImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            itemImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            itemImageView.widthAnchor.constraint(equalToConstant: 20),
            itemImageView.heightAnchor.constraint(equalToConstant: 20),
            
            itemNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            itemNameLabel.leftAnchor.constraint(equalTo: itemImageView.rightAnchor, constant: 15),
            
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.leftAnchor.constraint(equalTo: self.leftAnchor),
            button.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
}
