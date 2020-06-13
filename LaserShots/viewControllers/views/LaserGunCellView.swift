//
//  LaserGunView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class LaserGunCellView: LaserShotsBaseCellView {

    @IBOutlet weak var laserView: UIView!
    
    override func setupView() {
        super.setupView()
        self.laserView.isHidden = true
        self.gameCell?.onLaserBeamChanged = { (direction:PointingDirection, reflections:[PointingDirection]) -> () in
            if let gameCell = self.gameCell {
                self.laserView.isHidden = !gameCell.isReflecting()
            }
        }
    }
}
