//
//  gameProtocols.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation


enum cellType {
    case LaserGun
    case LaserDestination
    case Empty
    case Mirror
    case TransparentMirror
    case Wall
    case LaserTrap
}

enum pointingDirection:String {
    case up
    case down
    case left
    case right
    case none
}

protocol laserShotsDelegate:class {
    func gameState(state:gameState) ->()
    func levelLoaded() -> ()
}

protocol GameElement {
    var direction: pointingDirection { get set }
    func reflect(direction: pointingDirection) -> [pointingDirection]
}

extension GameElement {
    var isFlipable: Bool { return self is Flipable }
}

protocol Flipable {

}

extension Flipable where Self:GameElement {
    mutating func flip()  {
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


