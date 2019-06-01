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
        self.gameCell?.onLaserBeamChanged = { () -> () in
            self.laserView.isHidden = self.gameCell?.verticalBeam == nil && self.gameCell?.horizontalBeam == nil
            
        }
    }
    
    override func awakeFromNib() {
        self.laserView.isHidden = true
    }
    
}
