//
//  MirrorView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class MirrorCellView: LaserShotsBaseCellView {
  
    @IBOutlet weak var laserBeam2View: UIView!
    @IBOutlet weak var laserBeam1View: UIView!
    @IBOutlet weak var mirrorView: UIView!
    
    override func awakeFromNib() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
        self.mirrorView.transform = CGAffineTransform(rotationAngle: -.pi / 4)
        self.laserBeam2View.isHidden = true
        self.laserBeam1View.isHidden = true
    }
    
    override func setupView() {
        super.setupView()
        self.gameCell?.onLaserBeamChanged = { () -> () in
            let shouldhideBeams = self.gameCell?.horizontalBeam == nil && self.gameCell?.verticalBeam == nil
            self.laserBeam2View.isHidden = shouldhideBeams
            self.laserBeam1View.isHidden = shouldhideBeams
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let rotatingView = self.gameElementContainerView else {
            return
        }
        rotatingView.transform = rotatingView.transform.rotated(by:  .pi / 2)
        self.gameCell?.onTap()
    }

}
