//
//  LaserShotsInstructionsViewController.swift
//  LaserShots
//
//  Created by Damian Modernell on 04/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class LaserShotsInstructionsViewController: UIViewController {

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    var routingAction: (() -> Void)?
    
    @IBAction func onLetsGoButtonPressed(_ sender: Any) {
        self.routingAction?()
    }
}
