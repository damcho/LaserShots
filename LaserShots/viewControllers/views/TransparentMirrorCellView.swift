//
//  TransparentMirrorCellView.swift
//  LaserShots
//
//  Created by Damian Modernell on 01/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class TransparentMirrorCellView: LaserShotsBaseCellView {
    
    @IBOutlet weak var horizontalLaserBeam1: UIView!
    @IBOutlet weak var horizontalLaserBeam2: UIView!
    @IBOutlet weak var verticalLaserBeam1: UIView!
    @IBOutlet weak var verticalLaserBeam2: UIView!
    @IBOutlet weak var transparentMirrorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
        self.transparentMirrorView.transform = CGAffineTransform(rotationAngle: -.pi / 4)
        self.horizontalLaserBeam1.isHidden = true
        self.horizontalLaserBeam2.isHidden = true
        self.verticalLaserBeam1.isHidden = true
        self.verticalLaserBeam2.isHidden = true
        
    }
    
    override func setupView() {
        super.setupView()
        self.gameCell?.onLaserBeamChanged = { (direction:pointingDirection, reflections:[pointingDirection]) -> () in
            
            let shouldHideLaserBeams = self.gameCell?.laserBeam == nil
            let shouldShowHorizontalBeam = self.gameCell?.laserBeam == nil
            if shouldHideLaserBeams {
                self.horizontalLaserBeam2.isHidden = shouldHideLaserBeams
                self.horizontalLaserBeam1.isHidden = shouldHideLaserBeams
                self.verticalLaserBeam1.isHidden = shouldHideLaserBeams
                self.verticalLaserBeam2.isHidden = shouldHideLaserBeams
                
            } else if shouldShowHorizontalBeam && direction == .right{
                self.horizontalLaserBeam2.isHidden = !shouldShowHorizontalBeam
                self.horizontalLaserBeam1.isHidden = !shouldShowHorizontalBeam
                self.verticalLaserBeam1.isHidden = !shouldShowHorizontalBeam
                self.verticalLaserBeam2.isHidden = shouldShowHorizontalBeam
            } else if shouldShowHorizontalBeam && direction == .left {
                self.horizontalLaserBeam2.isHidden = !shouldShowHorizontalBeam
                self.horizontalLaserBeam1.isHidden = !shouldShowHorizontalBeam
                self.verticalLaserBeam1.isHidden = !shouldShowHorizontalBeam
                self.verticalLaserBeam2.isHidden = shouldShowHorizontalBeam
            }
            
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
