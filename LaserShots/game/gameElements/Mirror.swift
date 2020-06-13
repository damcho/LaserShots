//
//  Mirror.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class Mirror: GameElement, Rotatable {
    public var x: Int = -1
    public var y: Int = -1
    public var direction: pointingDirection
    
     public init(direction: pointingDirection, x: Int, y: Int) {
        self.direction = direction
        self.x = x
        self.y = y
    }
    
    public func reflect(direction: pointingDirection) -> [pointingDirection] {
        switch direction {
        case .down:
            if self.direction == .up {
                return [.left]
            } else if self.direction == .right {
                return [.right]
            } else {
                return []
            }
        case .up:
            if self.direction == .down {
                return [.right]
            } else if self.direction == .left {
                return [.left]
            } else {
                return []
            }
        case .left:
            if self.direction == .right {
                return [.up]
            } else if self.direction == .down {
                return [.down]
            } else {
                return []
            }
        case .right:
            if self.direction == .left {
                return [.down]
            } else if self.direction == .up {
                return [.up]
            } else {
                return []
            }
        default:
            return []
        }
    }
}
