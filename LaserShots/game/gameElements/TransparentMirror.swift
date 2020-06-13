//
//  TransparentMirror.swift
//  LaserShots
//
//  Created by Damian Modernell on 01/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class TransparentMirror: GameElement, Rotatable {
    public var x: Int
    public var y: Int
    public var direction: PointingDirection
    
    public init(direction: PointingDirection, x: Int, y: Int) {
        self.direction = direction
        self.x = x
        self.y = y
    }
}

extension TransparentMirror: Reflectable {
    public func reflect(direction: PointingDirection) -> [PointingDirection] {
        switch direction {
        case .down:
            if self.direction == .up {
                return [.left, .down]
            } else if self.direction == .right {
                return [.right, .down]
            } else {
                return []
            }
        case .up:
            if self.direction == .down {
                return [.right, .up]
            } else if self.direction == .left {
                return [.left, .up]
            } else {
                return []
            }
        case .left:
            if self.direction == .right {
                return [.up, .left]
            } else if self.direction == .down {
                return [.down, .left]
            } else {
                return []
            }
        case .right:
            if self.direction == .left {
                return [.down, .right]
            } else if self.direction == .up {
                return [.up, .right]
            } else {
                return []
            }
        default:
            return []
        }
    }
}
