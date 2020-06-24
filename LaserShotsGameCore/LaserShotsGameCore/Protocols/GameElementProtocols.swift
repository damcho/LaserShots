//
//  RotatableProtocol.swift
//  LaserShotsGameCore
//
//  Created by Damian Modernell on 6/24/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

typealias ReflectableDirectionableGameElement = GameElement & Directionable & Reflectable
typealias ReflectableRotatableGameElement = GameElement & Reflectable & Rotatable

public protocol Reflectable {
    func reflect(_ laser: Laser) -> [Laser]
}

public protocol Directionable: class  {
    var direction: PointingDirection { get set }
}

public protocol Rotatable: Directionable {
    func rotate()
}

extension Rotatable {
    public func rotate()  {
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

public protocol GameElement {}
public protocol GameTrap {}
public protocol GameDestination {}
public protocol Shooter {
    func shoot() -> Laser
}
