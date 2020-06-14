//
//  BoardCell.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class BoardCell: Equatable {
    
    let i:Int
    let j:Int
    var onLaserBeamChanged: ((PointingDirection, [PointingDirection]) -> ())?
    var onCellTapped: (() -> ())?
    var reflectableElement: Reflectable? 
    var laserBeam:Laser?
  
    init(i:Int, j:Int) {
        self.i = i
        self.j = j
    }
    
    public static func == (lhs: BoardCell, rhs: BoardCell) -> Bool {
        return lhs.i == rhs.i && lhs.j == rhs.j && type(of: lhs.reflectableElement) == type(of: rhs.reflectableElement)
    }
    
    func getDirection() -> PointingDirection {
        return reflectableElement is GameElement ? (reflectableElement as! GameElement).direction : .none
    }
    
    func isReflecting () -> Bool {
        return self.laserBeam != nil
    }
    
    func getLaserReflection(from:PointingDirection = .none) -> [PointingDirection] {
        var reflectDirections = [from]
    
        if let gameElement = self.reflectableElement {
            reflectDirections = gameElement.reflect(direction:from)
            if !reflectDirections.isEmpty {
                self.laserBeam = Laser(direction: from)
            }
        }
        self.onLaserBeamChanged?(from, reflectDirections)

        return reflectDirections
    }
    
    func onTap() {
        if let element = self.reflectableElement, element is Rotatable {
            let rotatableElement = element as! Rotatable
            rotatableElement.rotate()
            self.onCellTapped?()
        }
    }
    
    func clear() {
        self.laserBeam = nil
        self.onLaserBeamChanged?(.none, [])
    }
    
    func getInitialShotDirection() -> PointingDirection {
        guard let laserGun = (self.reflectableElement as? LaserGun) else {
            return .none
        }
        let laserDirection = laserGun.shoot()
        self.laserBeam = Laser(direction: laserDirection)
        self.onLaserBeamChanged?(laserDirection, [laserDirection])
        return laserDirection
    }
}
