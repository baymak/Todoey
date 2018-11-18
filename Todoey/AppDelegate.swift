//
//  AppDelegate.swift
//  Todoey
//
//  Created by buket aymak on 4.11.2018.
//  Copyright © 2018 buket aymak. All rights reserved.
//

import UIKit

import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISearchBarDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        do {
            _ = try Realm()
           
        }
        catch {
            print("error initialising new Realm \(error)")
        }
        return true
    }
    
 
   
}

