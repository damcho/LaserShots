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
    var laserBeam: Laser? {
        didSet {
            self.onLaserBeamChanged?(laserBeam , reflectedLaserBeams)
        }
    }
    private var reflectedLaserBeams: [Laser]
    
    init(i:Int, j:Int) {
        self.i = i
        self.j = j
        reflectedLaserBeams = []
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
        return !self.reflectedLaserBeams.isEmpty
    }
    
    func reflect(_ laser: Laser) -> [Laser] {
        self.reflectedLaserBeams = [laser]
        if let gameElement = self.gameElement {
            self.reflectedLaserBeams = gameElement is Reflectable ?
                (gameElement as! Reflectable).reflect(laser) : []
        }
        self.laserBeam = laser
        return self.reflectedLaserBeams
    }
    
    func performAction() {
        if self.gameElement is Rotatable {
            (self.gameElement as! Rotatable).rotate()
            self.onCellAction?()
        }
    }
    
    func clear() {
        self.reflectedLaserBeams = []
        self.laserBeam = nil
    }
    
    func getInitialLaser() -> Laser? {
        guard let laserGun = (self.gameElement as? Shooter) else {
            return nil
        }
        let initialLaserBeam =  laserGun.shoot()
        self.reflectedLaserBeams = [initialLaserBeam]
        self.laserBeam = initialLaserBeam
        return self.laserBeam
    }
}
