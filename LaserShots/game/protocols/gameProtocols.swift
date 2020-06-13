//
//  gameProtocols.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation


public enum CellType: String {
    case LaserGun
    case LaserDestination
    case Empty
    case Mirror
    case TransparentMirror
    case Wall
    case LaserTrap
}

public enum PointingDirection:String {
    case up
    case down
    case left
    case right
    case none
}

protocol BoardLoaderDelegate: class {
    func levelLoaded(board:[[BoardCell]], laserGun:BoardCell)
}

protocol laserShotsDelegate:class {
    func gameState(state:gameState) ->()
    func levelLoaded() -> ()
}

public protocol Reflectable {
    var direction: PointingDirection { get set }

    func reflect(direction: PointingDirection) -> [PointingDirection]
}

public protocol GameElement: Reflectable {
    var x: Int { get set }
    var y: Int { get set }
}

protocol Rotatable: GameElement {
    mutating func rotate()
}

extension Rotatable where Self:GameElement {
    mutating func rotate()  {
        var newDirection = self.direction
        switch direction {
        case .down:
            newDirection = .left
        case .up:
            newDirection = .right
        case .left:
            newDirection = .up
        case .right:
            newDirection = .down
        default:
            newDirection = .none
        }
        self.direction = newDirection
    }
}


