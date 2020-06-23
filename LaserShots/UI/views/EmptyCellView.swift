//
//  EmptyCellView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit
import LaserShotsGameCore

class EmptyCellView: LaserShotsBaseCellView {
    
    @IBOutlet weak var horizontalLaserView: UIView!
    @IBOutlet weak var verticalLaserView: UIView!
    
    private func hideBeams(_ shouldHide: Bool) {
        self.horizontalLaserView.isHidden = shouldHide
        self.verticalLaserView.isHidden = shouldHide
    }
    
    override func setupView() {
        self.hideBeams(true)
        self.gameCellViewModel?.onLaserBeamChanged = { (laser, reflections) -> () in
            guard let laserBeam = laser else {
                self.hideBeams(true)
                return
            }

            if laserBeam.direction == .up || laserBeam.direction == .down {
                self.verticalLaserView.isHidden = false
            } else {
                self.horizontalLaserView.isHidden = false
            }
        }
    }
    
}
