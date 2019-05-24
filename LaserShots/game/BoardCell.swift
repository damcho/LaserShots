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
            self.verticalBeam = nil
            self.horizontalBeam = nil
        }
    }
    
    func getLaserDirection(direction:pointingDirection = .none) -> pointingDirection {
        self.wasHitByLaser(direction: direction)
        
        if self.cellType == .Empty {
            self.onLaserBeamChanged?()
            return direction
        } else if self.cellType == .LaserGun {
            return self.gameElement?.direction ?? .none
        } else if self.gameElement is Reflectable {
            let newDirection = (self.gameElement as! Reflectable).reflectfrom(direction)
            if newDirection != .none {
                self.onLaserBeamChanged?()
            }
            return newDirection
        } else {
            return .none
        }
    }
    
    func onTap() {
        if self.gameElement is Flipable {
            (self.gameElement as! Flipable).flip()
            self.onCellTapped?()
        }
    }
    
    func clear() {
        self.horizontalBeam = nil
        self.verticalBeam = nil
        self.onLaserBeamChanged?()
    }
    
    var description : String {
        get {
            return "x:`\(i) `\(j) `\(gameElement)"
        }
    }
}
