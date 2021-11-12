//
//  AppDelegate.swift
//  Memo
//
//  Created by Ahyeonway on 2021/11/08.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var firstLaunch: FirstLaunch?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let source = UserDefaultsFirstLaunchDataSource(defaults: .standard, key: "com.arie.Memo")
//        self.firstLaunch = FirstLaunch(source: source)

        #if DEBUG
            self.firstLaunch = FirstLaunch.alwaysFirst()
        #else
            let source = UserDefaultsFirstLaunchDataSource(defaults: .standard, key: "com.arie.Memo")
            self.firstLaunch = FirstLaunch(source: source)
        #endif
        
        // appearance
        UILabel.appearance().textColor = .white
        UITableView.appearance().backgroundColor = .black
        UITableViewCell.appearance().backgroundColor = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 0.4)
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().textColor = .white
        UITextView.appearance().font = UIFont().textViewStyle
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "취소"
        UIBarButtonItem.appearance().tintColor = .systemGreen
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [.foregroundColor: UIColor.white]
        
        UIToolbarAppearance().configureWithTransparentBackground()
        UIToolbarAppearance().backgroundColor = .clear
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

