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
    var onCellAction: (() -> ())?
    var gameElement: GameElement?
    var laserBeam:Laser?
    
    init(i:Int, j:Int) {
        self.i = i
        self.j = j
    }
    
    public static func == (lhs: BoardCell, rhs: BoardCell) -> Bool {
        return lhs.i == rhs.i && lhs.j == rhs.j && type(of: lhs.gameElement) == type(of: rhs.gameElement)
    }
    
    func getDirection() -> PointingDirection {
        return gameElement is Directionable ? (gameElement as! Directionable).direction : .none
    }
    
    func isReflecting () -> Bool {
        return self.laserBeam != nil
    }
    
    func getLaserReflection(originDirection: PointingDirection = .none) -> [PointingDirection] {
        var reflectDirections: [PointingDirection] = [originDirection]
        
        if let gameElement = self.gameElement {
            if gameElement is Reflectable {
                reflectDirections = (gameElement as! Reflectable).reflect(direction: originDirection)
                if !reflectDirections.isEmpty {
                    self.laserBeam = Laser(direction: originDirection)
                }
            } else {
                reflectDirections = []
            }
        }
        self.onLaserBeamChanged?(originDirection, reflectDirections)
        
        return reflectDirections
    }
    
    func onTap() {
        if let element = self.gameElement, element is Rotatable {
            let rotatableElement = element as! Rotatable
            rotatableElement.rotate()
            self.onCellAction?()
        }
    }
    
    func clear() {
        self.laserBeam = nil
        self.onLaserBeamChanged?(.none, [])
    }
    
    func getInitialShotDirection() -> PointingDirection {
        guard let laserGun = (self.gameElement as? Shooter) else {
            return .none
        }
        let laserDirection = laserGun.shoot()
        self.laserBeam = Laser(direction: laserDirection)
        self.onLaserBeamChanged?(laserDirection, [laserDirection])
        return laserDirection
    }
}
