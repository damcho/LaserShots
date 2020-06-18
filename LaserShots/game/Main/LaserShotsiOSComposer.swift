//
//  LaserShotsiOSComposer.swift
//  LaserShots
//
//  Created by Damian Modernell on 6/16/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

final class LaserShotsiOSComposer {
    
    static func composeWith(laserShotsGame: LaserShotsGame) -> UIViewController?{
        guard let laserInstructionsVC = LaserShotsInstructionsViewController.loadFromStoryboard() as? LaserShotsInstructionsViewController else { return nil}
        
        laserInstructionsVC.routingAction = {
            let laserShotsGameViewModel = LaserGameViewModel(laserShotsGame: laserShotsGame)
            
            guard let laserShotsGameViewController = LaserShotsViewController.loadFromStoryboard() as? LaserShotsViewController else { return }
            laserShotsGameViewController.laserShotsGameViewModel = laserShotsGameViewModel
            laserInstructionsVC.navigationController?.pushViewController(laserShotsGameViewController, animated: true)
        }
        return laserInstructionsVC
    }
}
