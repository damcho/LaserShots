//
//  Mirror.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class Mirror: GameElement, Flipable {
    var direction: pointingDirection
    
    init?(jsonElement:Dictionary<String, Any>) {
        
        guard let direction = jsonElement["direction"] as? String else {
            return nil
        }
        self.direction = pointingDirection(rawValue:direction) ?? .down
    }

    func reflect(direction: pointingDirection) -> [pointingDirection] {
        switch direction {
        case .down:
            if self.direction == .up {
                return [.left]
            } else if self.direction == .right {
                return [.right]
            } else {
                return [.none]
            }
        case .up:
            if self.direction == .down {
                return [.right]
            } else if self.direction == .left {
                return [.left]
            } else {
                return [.none]
            }
        case .left:
            if self.direction == .right {
                return [.up]
            } else if self.direction == .down {
                return [.down]
            } else {
                return [.none]
            }
        case .right:
            if self.direction == .left {
                return [.down]
            } else if self.direction == .up {
                return [.up]
            } else {
                return [.none]
            }
        default:
            return [.none]
        }
    }
}
