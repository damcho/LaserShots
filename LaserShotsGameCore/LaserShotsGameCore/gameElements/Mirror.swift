//
//  Mirror.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class Mirror: ReflectableRotatableGameElement {
    public var direction: PointingDirection
    
     public init(direction: PointingDirection) {
        self.direction = direction
    }
}

extension Mirror {
    public func reflect(direction: PointingDirection) -> [PointingDirection] {
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
    
 

