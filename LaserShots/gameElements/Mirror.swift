//
//  Mirror.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class Mirror: GameElement, Flipable, Reflectable {    
    var direction: pointingDirection
    
    init?(jsonElement:Dictionary<String, Any>) {
        
        guard let direction = jsonElement["direction"] as? String else {
            return nil
        }
        self.direction = pointingDirection(rawValue:direction) ?? .down
    }
    
    func flip()  {
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
    
    func reflectfrom(_ direction: pointingDirection) -> pointingDirection {
        switch direction {
        case .down:
            if self.direction == .up {
                return .left
            } else if self.direction == .right {
                return .right
            } else {
                return .none
            }
        case .up:
            if self.direction == .up {
                return .left
            } else if self.direction == .right {
                return .right
            } else {
                return .none
            }
        case .left:
            if self.direction == .left {
                return .down
            } else if self.direction == .down {
                return .left
            } else {
                return .none
            }
        case .right:
            if self.direction == .right {
                return .up
            } else if self.direction == .down {
                return .down
            } else {
                return .none
            }
        default:
            return.none
        }
    }
    
    

  
    
    
}
