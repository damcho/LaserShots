//
//  LaserShotsInstructionsViewController.swift
//  LaserShots
//
//  Created by Damian Modernell on 04/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class LaserShotsInstructionsViewController: UIViewController {

    
    @IBAction func onLetsGoButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let laserShotGameVC = storyboard.instantiateViewController(withIdentifier: "LaserShotsViewController")

        self.navigationController?.pushViewController(laserShotGameVC, animated: true)
    }
    
}
