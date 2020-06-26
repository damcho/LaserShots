//
//  LaserShotsBaseCellView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit
import LaserShotsGameCore

class LaserShotsBaseCellView: UICollectionViewCell, NibInstantiatable {
    
    @IBOutlet weak var gameElementContainerView: UIView?
    var laserReflectionsView: ReflectionsView?
    
    override func awakeFromNib() {
        let reflectionsView = ReflectionsView.fromNib()
        reflectionsView.frame = self.bounds
        self.laserReflectionsView = reflectionsView
        self.insertSubview(reflectionsView, at: 0)
    }
    
    var gameCellViewModel: CellViewModel? {
        didSet {
            self.setupView()
        }
    }
    
    func setupView() {
        self.laserReflectionsView?.hideBeams(true)
        self.gameCellViewModel?.onLaserBeamChanged = {[weak self] (laser, reflections) -> () in
            guard let laserBeam = laser else {
                self?.laserReflectionsView?.hideBeams(true)
                return
            }
            self?.laserReflectionsView?.setOriginLaserView(laser: laserBeam)
            reflections.forEach { (reflectedLaser) in
                self?.laserReflectionsView?.setLaserViewFor(laser: reflectedLaser)
            }
        }
        self.rotate()
    }
    
    func rotate(){
        guard let viewModel = self.gameCellViewModel else {
            return
        }
        var radiansToRotate:CGFloat
        switch viewModel.direction() {
        case .left:
            radiansToRotate = .pi/2
        case .right:
            radiansToRotate = .pi * 3/2
        case .up:
            radiansToRotate = .pi
        default:
            radiansToRotate = 0
        }
        self.gameElementContainerView?.transform = CGAffineTransform(rotationAngle: radiansToRotate)
    }
}
