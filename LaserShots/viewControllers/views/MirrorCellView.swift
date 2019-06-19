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
        self.laserBeam2View.isHidden = true
        self.laserBeam1View.isHidden = true
        self.gameCell?.onLaserBeamChanged = {[weak self] (direction:pointingDirection, reflections:[pointingDirection]) -> () in
            let shouldShowLaserBeam = !reflections.isEmpty || self?.gameCell?.isReflecting() ?? false
            self?.laserBeam2View.isHidden = !shouldShowLaserBeam
            self?.laserBeam1View.isHidden = !shouldShowLaserBeam
        }
    }
}
