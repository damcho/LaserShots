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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
    }
    
    override func setupView() {
        super.setupView()
        self.horizontalLaserBeam1.isHidden = true
        self.horizontalLaserBeam2.isHidden = true
        self.verticalLaserBeam1.isHidden = true
        self.verticalLaserBeam2.isHidden = true
        guard let rotatingView = self.gameElementContainerView else {
            return
        }
        rotatingView.transform = rotatingView.transform.rotated(by:  -.pi / 4)

        self.gameCell?.onLaserBeamChanged = {[weak self] (direction:pointingDirection, reflections:[pointingDirection]) -> () in
            guard let gameCell = self?.gameCell else {
                return
            }
            let shouldHideLaserBeams = !gameCell.isReflecting()
            
            if shouldHideLaserBeams {
                self?.horizontalLaserBeam2.isHidden = shouldHideLaserBeams
                self?.horizontalLaserBeam1.isHidden = shouldHideLaserBeams
                self?.verticalLaserBeam1.isHidden = shouldHideLaserBeams
                self?.verticalLaserBeam2.isHidden = shouldHideLaserBeams
                
            } else if direction == .right || direction == .left{
                self?.horizontalLaserBeam2.isHidden = false
                self?.horizontalLaserBeam1.isHidden = false
                for laserDirection in reflections {
                    if laserDirection == .up {
                        self?.verticalLaserBeam1.isHidden = false
                    } else if laserDirection == .down{
                        self?.verticalLaserBeam2.isHidden = false
                    }
                }
            } else if direction == .up || direction == .down {
                for laserDirection in reflections {
                    if laserDirection == .left {
                        self?.horizontalLaserBeam1.isHidden = false
                    } else if laserDirection == .right{
                        self?.horizontalLaserBeam2.isHidden = false
                    }
                }
                self?.verticalLaserBeam1.isHidden = false
                self?.verticalLaserBeam2.isHidden = false
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
