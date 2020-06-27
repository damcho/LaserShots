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
    
    var laserReflectionsView: ReflectionsView?
    @IBOutlet weak var gameElementView: UIView!

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
        self.setupCellPosition()
        self.laserReflectionsView?.hideBeams(true)
        
        self.gameCellViewModel?.onLaserBeamChanged = {[weak self] (laser, reflections) -> () in
            guard let laserBeam = laser else {
                self?.laserReflectionsView?.hideBeams(true)
                return
            }
            self?.laserReflectionsView?.setOriginLaserView(laser: laserBeam)
            self?.laserReflectionsView?.setLaserReflectionsfor(lasers: reflections)
        }
    }
    
    
    func setupCellPosition(){
        if self is DirectionableCell {
            (self as! DirectionableCell).setupInitialDirection()
        }
    }
}
