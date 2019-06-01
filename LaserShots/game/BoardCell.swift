//
//  BoardCell.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class BoardCell {
    
    let i:Int
    let j:Int
    var onLaserBeamChanged: (() -> ())?
    var onCellTapped: (() -> ())?
    var cellType:cellType = .Empty
    var gameElement:GameElement? {
        didSet {
            self.setupCell()
        }
    }
    var horizontalBeam:Laser?
    var verticalBeam:Laser?
  
    
    init(i:Int, j:Int) {
        self.i = i
        self.j = j
    }
    
    private func setupCell() {
        self.setCellType()
    }
    
    
    func setCellType() {
        if self.gameElement is LaserGun {
            cellType = .LaserGun
        } else if self.gameElement is LaserDestination {
            cellType = .LaserDestination
        } else if self.gameElement is Mirror {
            cellType = .Mirror
        } else if self.gameElement is Wall{
            cellType = .Wall
        } else if self.gameElement is LaserTrap{
            cellType = .LaserTrap
        } else if self.gameElement is TransparentMirror{
            cellType = .TransparentMirror
        }
    }
    
    func rotation() -> Double{
        guard let gameElement = self.gameElement else {
            return 0
        }
        switch gameElement.direction {
        case .left:
            return .pi/2
        case .right:
            return .pi * 3/2
        case .up:
            return .pi
        default:
            return 0
        }
    }
    
    func wasHitByLaser(direction:pointingDirection) {
        switch direction {
        case .down, .up:
            self.verticalBeam = Laser(direction: direction)
        case .left, .right:
            self.horizontalBeam = Laser(direction: direction)
        case .none:
            if self.gameElement is LaserDestination {
                self.horizontalBeam = Laser(direction: direction)
            }
           break
        }
        self.onLaserBeamChanged?()
    }
    
    private func isReflecting () -> Bool {
        return self.horizontalBeam != nil || self.verticalBeam != nil
    }
    
    func getLaserReflection(from:pointingDirection = .none) -> [pointingDirection] {
        var reflectDirections = [from]
    
        if let gameElement = self.gameElement {
            reflectDirections = gameElement.reflect(direction:from)
        }
        self.wasHitByLaser(direction: reflectDirections[0])

        return reflectDirections
    }
    
    func onTap() {
        if let element = self.gameElement, element.isFlipable {
            var flipableElement = element as! Flipable & GameElement
            flipableElement.flip()
            self.onCellTapped?()
        }
    }
    
    func clear() {
        self.horizontalBeam = nil
        self.verticalBeam = nil
        self.onLaserBeamChanged?()
    }
    
    func getInitialShot() -> pointingDirection {
        if let laserGun = (self.gameElement as? LaserGun) {
            let laserDirection = laserGun.shoot()
            self.horizontalBeam = Laser(direction: laserDirection)
            self.onLaserBeamChanged?()
            return laserDirection
        } else {
            return .none
        }
    }
}
