//
//  EmptyCellView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class EmptyCellView: LaserShotsBaseCellView {

   
    
    override func setupView() {
        super.setupView()
        self.gameCell?.onLaserHit = { () -> () in
            self.gameElementContainerView.isHidden = self.gameCell?.laserBeam == nil
            self.gameElementContainerView.transform = CGAffineTransform(rotationAngle: CGFloat( CGFloat( self.gameCell?.laserRotation() ?? 0)))

         //   self.gameElementContainerView.transform.rotated(by:)

        }
    }
    
    override func awakeFromNib() {
        self.gameElementContainerView.isHidden = true
    }
    
    override internal func rotate() {
       
    }
}
