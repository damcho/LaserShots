//
//  gameProtocols.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation


public enum CellType: String {
    case laserGun
    case laserDestination
    case empty
    case mirror
    case transparentMirror
    case wall
    case laserTrap
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
    func gameState(state:GameState) ->()
    func levelLoaded() -> ()
}

public protocol Reflectable {
    func reflect(direction: PointingDirection) -> [PointingDirection]
}

public protocol GameElement: class, Reflectable  {
    var x: Int { get set }
    var y: Int { get set }
    var direction: PointingDirection { get set }
}

protocol Rotatable: GameElement {
    func rotate()
}

extension Rotatable {
    func rotate()  {
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


