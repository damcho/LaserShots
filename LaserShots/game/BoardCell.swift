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
    var onLaserBeamChanged: ((pointingDirection, [pointingDirection]) -> ())?
    var onCellTapped: (() -> ())?
    var cellType:cellType = .Empty
    var gameElement:GameElement? {
        didSet {
            self.setupCell()
        }
    }
    var laserBeam:Laser?
  
    
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
    
    func getDirection() -> pointingDirection {
        return self.gameElement?.direction ?? .none
    }
    
    func isReflecting () -> Bool {
        return self.laserBeam != nil
    }
    
    func getLaserReflection(from:pointingDirection = .none) -> [pointingDirection] {
        var reflectDirections = [from]
    
        if let gameElement = self.gameElement {
            reflectDirections = gameElement.reflect(direction:from)
            if !reflectDirections.isEmpty {
                self.laserBeam = Laser(direction: from)
            }
        }
        self.onLaserBeamChanged?(from, reflectDirections)

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
        self.laserBeam = nil
        self.onLaserBeamChanged?(.none, [])
    }
    
    func getInitialShotDirection() -> pointingDirection {
        guard let laserGun = (self.gameElement as? LaserGun) else {
            return .none
        }
        let laserDirection = laserGun.shoot()
        self.laserBeam = Laser(direction: laserDirection)
        self.onLaserBeamChanged?(laserDirection, [laserDirection])
        return laserDirection
    }
}
