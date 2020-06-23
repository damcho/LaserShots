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
    var onLaserBeamChanged: ((Laser?, [Laser]) -> ())?
    var onCellAction: (() -> ())?
    var gameElement: GameElement?
    var inwardLaserBeam: Laser?
    private var outwardLaserBeams: [Laser] {
        didSet {
            self.onLaserBeamChanged?(inwardLaserBeam , outwardLaserBeams)
        }
    }
    
    init(i:Int, j:Int) {
        self.i = i
        self.j = j
        outwardLaserBeams = []
    }
    
    public static func == (lhs: BoardCell, rhs: BoardCell) -> Bool {
        return lhs.i == rhs.i && lhs.j == rhs.j && type(of: lhs.gameElement) == type(of: rhs.gameElement)
    }
    
    func getDirection() -> PointingDirection {
        guard let element = self.gameElement else {
            return .none
        }
        return element is Directionable ? (element as! Directionable).direction : .none
    }
    
    func isReflecting () -> Bool {
        return !self.outwardLaserBeams.isEmpty
    }
    
    func reflect(_ laser: Laser) -> [Laser] {
        self.inwardLaserBeam = laser
        var reflectingLasers: [Laser] = [laser]
        if let gameElement = self.gameElement {
            reflectingLasers = gameElement is Reflectable ?
                (gameElement as! Reflectable).reflect(laser) : []
            self.outwardLaserBeams.append(contentsOf: reflectingLasers)
        } else {
            self.outwardLaserBeams = [laser]
        }
        return reflectingLasers
    }
    
    func performAction() {
        if self.gameElement is Rotatable {
            (self.gameElement as! Rotatable).rotate()
            self.onCellAction?()
        }
    }
    
    func clear() {
        self.inwardLaserBeam = nil
        self.outwardLaserBeams = []
    }
    
    func getInitialLaser() -> Laser? {
        guard let laserGun = (self.gameElement as? Shooter) else {
            return nil
        }
        let initialLaserBeam =  laserGun.shoot()
        self.inwardLaserBeam = initialLaserBeam
        self.outwardLaserBeams = [initialLaserBeam]
        return self.inwardLaserBeam
    }
}
