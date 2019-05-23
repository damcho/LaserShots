//
//  BoardCell.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class BoardCell:CustomStringConvertible {
    
    let i:Int
    let j:Int
    var onLaserHit: (() -> ())?
    var onCellTapped: (() -> ())?
    var cellType:cellType = .Empty
    var gameElement:GameElement? {
        didSet {
            self.setupCell()
        }
    }
    var laserBeam:Laser? {
        didSet {
            self.onLaserHit?()
        }
    }
  
    
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
    
    func laserRotation() -> Double {
        guard let laserBeam = self.laserBeam else {
            return 0
        }
        switch laserBeam.direction {
        case .down:
            return 0
        case .left:
            return .pi/1
        case .right:
            return .pi/2
        case .up:
            return .pi
        default:
            return 0
        }
    }
    
    var description : String {
        get {
            return "x:`\(i) `\(j) `\(gameElement)"
        }
    }
    
    func getLaserDirection(direction:pointingDirection = .none) -> pointingDirection {
        if self.gameElement == nil {
            self.laserBeam = Laser(direction: direction)
            return direction
        } else if self.cellType == .LaserGun {
            return self.gameElement?.direction ?? .none
        } else if self.gameElement is Reflectable {
            return (self.gameElement as! Reflectable).reflectfrom(direction)
        } else {
            return .none
        }
    }
    
    func hasLaserBeam() -> Bool {
        return self.laserBeam != nil
    }
    
    func onTap() {
        if self.gameElement is Flipable {
            (self.gameElement as! Flipable).flip()
            self.onCellTapped?()
        }
    }
    
    func clear() {
        self.laserBeam = nil
    }
    
}
