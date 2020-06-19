//
//  MirrorView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit
import LaserShotsGameCore

class MirrorCellView: RotatableCellView {
    
    @IBOutlet weak var laserBeam2View: UIView!
    @IBOutlet weak var laserBeam1View: UIView!
    @IBOutlet weak var mirrorView: UIView!
    
    override func setupView() {
        super.setupView()
        self.shouldShowLaserBeam(false)
        self.mirrorView.transform = CGAffineTransform(rotationAngle: -.pi / 4)
        
        self.gameCellViewModel?.onLaserBeamChanged = {[weak self] (direction:PointingDirection, reflections:[PointingDirection]) -> () in
            let shouldShowLaserBeam = !reflections.isEmpty || self?.gameCellViewModel?.isReflecting() ?? false
            self?.shouldShowLaserBeam( shouldShowLaserBeam)
        }
    }
    
    private func shouldShowLaserBeam(_ should:Bool) {
        self.laserBeam2View.isHidden = !should
        self.laserBeam1View.isHidden = !should
    }
    
    @objc override func handleTap(_ sender: UITapGestureRecognizer) {
        self.shouldShowLaserBeam(false)
        super.handleTap(sender)
    }
}
