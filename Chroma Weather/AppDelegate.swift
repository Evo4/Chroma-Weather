//
//  AppDelegate.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 16.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "737174957061-ccoouasgtksl05vl0cr296ut7t14vqe3.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        
        
        if #available(iOS 13.0, *) {
        } else {
            window = UIWindow()
            window?.makeKeyAndVisible()
            if let _ = Settings.shared.userIdToken {
                let mainVC = MainView()
                window?.rootViewController = mainVC
            } else {
                let signInVC = SignInView()
                window?.rootViewController = signInVC
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        return GIDSignIn.sharedInstance().handle(url)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          return
        }
        // Perform any operations on signed in user here.
        let idToken = user.authentication.idToken
        Settings.shared.serializeUserIdToken(token: idToken)
        if let _ = idToken {
            let mainView = MainView()
            mainView.modalPresentationStyle = .fullScreen
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
            rootViewController?.present(mainView, animated: true, completion: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
}

