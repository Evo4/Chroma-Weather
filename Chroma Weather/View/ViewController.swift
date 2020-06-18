//
//  ViewController.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 16.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class ViewController: UIViewController {

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "Splash")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var googleSignInButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var facebookSignInButton: FBLoginButton = {
        let button = FBLoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupConstraints()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        facebookSignInButton.permissions = ["public_profile", "email"]
    }

    func setupConstraints() {
        [backgroundImageView, googleSignInButton, facebookSignInButton].forEach { (subview) in
            view.addSubview(subview)
        }
        
        let layoutConstraintsArr = facebookSignInButton.constraints
        for lc in layoutConstraintsArr {
            if ( lc.constant == 28 ){
                lc.isActive = false
                break
            }
        }
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            facebookSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            facebookSignInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            facebookSignInButton.widthAnchor.constraint(equalToConstant: 245),
            facebookSignInButton.heightAnchor.constraint(equalToConstant: 40),
            
            googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleSignInButton.bottomAnchor.constraint(equalTo: facebookSignInButton.topAnchor, constant: -15),
            googleSignInButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    
}

