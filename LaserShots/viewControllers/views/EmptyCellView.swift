//
//  EmptyCellView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class EmptyCellView: LaserShotsBaseCellView {
    
    @IBOutlet weak var horizontalLaserView: UIView!
    @IBOutlet weak var verticalLaserView: UIView!
    
    override func setupView() {
        self.horizontalLaserView.isHidden = true
        self.verticalLaserView.isHidden = true
        self.gameCellViewModel?.onLaserBeamChanged = { (direction:PointingDirection, reflections:[PointingDirection]) -> () in
            if direction == .none {
                self.horizontalLaserView.isHidden = true
                self.verticalLaserView.isHidden = true
            } else if  direction == .up || direction == .down {
                self.verticalLaserView.isHidden = false
            } else {
                self.horizontalLaserView.isHidden = false
            }
        }
    }
    
}
