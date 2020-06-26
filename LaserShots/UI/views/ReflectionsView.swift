//
//  EmptyCellView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit
import LaserShotsGameCore

class ReflectionsView: UIView, NibInstantiatable {
    
    @IBOutlet weak var LeftHorizontalLaserView: UIView!
    @IBOutlet weak var bottomVerticalLaserView: UIView!
    @IBOutlet weak var rightHorizontalLaserView: UIView!
    @IBOutlet weak var topVerticalLaserView: UIView!
    
    func hideBeams(_ shouldHide: Bool) {
        self.LeftHorizontalLaserView.isHidden = shouldHide
        self.bottomVerticalLaserView.isHidden = shouldHide
        self.topVerticalLaserView.isHidden = shouldHide
        self.rightHorizontalLaserView.isHidden = shouldHide
    }
    
    func setOriginLaserView(laser: Laser) {
        switch laser.direction {
        case .down:
            self.topVerticalLaserView.isHidden = false
        case .up:
            self.bottomVerticalLaserView.isHidden = false
        case .left:
            self.rightHorizontalLaserView.isHidden = false
        case .right:
            self.LeftHorizontalLaserView.isHidden = false
        default:
            break
        }
    }
    
    func setLaserViewFor(laser: Laser) {
        switch laser.direction {
        case .down:
            self.bottomVerticalLaserView.isHidden = false
        case .up:
            self.topVerticalLaserView.isHidden = false
        case .left:
            self.LeftHorizontalLaserView.isHidden = false
        case .right:
            self.rightHorizontalLaserView.isHidden = false
        default:
            break
        }
    }
}
