//
//  MirrorView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class MirrorCellView: RotatableCellView {
  
    @IBOutlet weak var laserBeam2View: UIView!
    @IBOutlet weak var laserBeam1View: UIView!
    @IBOutlet weak var mirrorView: UIView!
    
    override func setupView() {
        super.setupView()
        self.mirrorView.transform = CGAffineTransform(rotationAngle: -.pi / 4)
        self.shouldShowLaserBeam(false)

        self.gameCell?.onLaserBeamChanged = {[weak self] (direction:pointingDirection, reflections:[pointingDirection]) -> () in
            let shouldShowLaserBeam = !reflections.isEmpty || self?.gameCell?.isReflecting() ?? false
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
