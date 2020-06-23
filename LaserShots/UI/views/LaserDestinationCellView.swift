//
//  LaserDestinationView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit
import LaserShotsGameCore

class LaserDestinationCellView: LaserShotsBaseCellView {
    
    @IBOutlet weak var laserView: UIView!

    override func setupView() {
        super.setupView()
        self.laserView.isHidden = true
        self.gameCellViewModel?.onLaserBeamChanged = { [weak self] (laser, reflections) in
            self?.laserView.isHidden = laser == nil
        }
    }
}
