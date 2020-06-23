//
//  TransparentMirrorCellView.swift
//  LaserShots
//
//  Created by Damian Modernell on 01/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit
import LaserShotsGameCore

class TransparentMirrorCellView: RotatableCellView {
    
    @IBOutlet weak var horizontalLaserBeam1: UIView!
    @IBOutlet weak var horizontalLaserBeam2: UIView!
    @IBOutlet weak var verticalLaserBeam1: UIView!
    @IBOutlet weak var verticalLaserBeam2: UIView!
    
    private func hideLaserBeams(_ shouldHide: Bool) {
        self.horizontalLaserBeam1.isHidden = shouldHide
        self.horizontalLaserBeam2.isHidden = shouldHide
        self.verticalLaserBeam1.isHidden = shouldHide
        self.verticalLaserBeam2.isHidden = shouldHide
    }
    
    override func setupView() {
        super.setupView()
        hideLaserBeams(true)
        
        guard let rotatingView = self.gameElementContainerView else {
            return
        }
        rotatingView.transform = rotatingView.transform.rotated(by:  -.pi / 4)
        
        self.gameCellViewModel?.onLaserBeamChanged = {[weak self] (laser, reflections) -> () in
            guard let laserBeam = laser else {
                self?.hideLaserBeams(true)
                return
            }
            
            if reflections.isEmpty {
                self?.hideLaserBeams(true)
            } else if laserBeam.direction == .right || laserBeam.direction == .left{
                self?.horizontalLaserBeam2.isHidden = false
                self?.horizontalLaserBeam1.isHidden = false
                for laser in reflections {
                    if laser.direction == .up {
                        self?.verticalLaserBeam1.isHidden = false
                    } else if laser.direction == .down{
                        self?.verticalLaserBeam2.isHidden = false
                    }
                }
            } else if laserBeam.direction == .up || laserBeam.direction == .down {
                for laser in reflections {
                    if laser.direction == .left {
                        self?.horizontalLaserBeam1.isHidden = false
                    } else if laser.direction == .right{
                        self?.horizontalLaserBeam2.isHidden = false
                    }
                }
                self?.verticalLaserBeam1.isHidden = false
                self?.verticalLaserBeam2.isHidden = false
            }
        }
    }
}
