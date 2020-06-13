//
//  TransparentMirror.swift
//  LaserShots
//
//  Created by Damian Modernell on 01/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class TransparentMirror: GameElement, Rotatable {
    public var x: Int = -1
    public var y: Int = -1
    public var direction: pointingDirection
    
    public init(direction: pointingDirection, x: Int, y: Int) {
        self.direction = direction
        self.x = x
        self.y = y
    }
    
    init?(jsonElement:Dictionary<String, Any>) {
        
        guard let direction = jsonElement["direction"] as? String else {
            return nil
        }
        self.direction = pointingDirection(rawValue:direction) ?? .down
    }
    
    public func reflect(direction: pointingDirection) -> [pointingDirection] {
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
