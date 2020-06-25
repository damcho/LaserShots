//
//  AppDelegate.swift
//  LaserShots
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit
import LaserShotsGameCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let levelLoaderClient = BundleJSONLevelLoaderClient(bundle: Bundle(for: BundleJSONLevelLoaderClient.self))
        let game = LaserShotsGame(levelLoader: LevelLoader(client: levelLoaderClient))
        guard let rootvc = LaserShotsiOSComposer.composeWith(laserShotsGame: game) else { return false }
        window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController(rootViewController: rootvc)
        navController.isNavigationBarHidden = true
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        return true
    }
}

