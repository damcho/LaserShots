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
    public func reflect(_ laser: Laser) -> [Laser] {
        switch laser.direction {
         case .down:
             if self.direction == .up {
                 return [Laser(direction: .left)]
             } else if self.direction == .right {
                 return [Laser(direction: .right)]
             } else {
                 return []
             }
         case .up:
             if self.direction == .down {
                 return [Laser(direction: .right)]
             } else if self.direction == .left {
                 return [Laser(direction: .left)]
             } else {
                 return []
             }
         case .left:
             if self.direction == .right {
                 return [Laser(direction: .up)]
             } else if self.direction == .down {
                 return [Laser(direction: .down)]
             } else {
                 return []
             }
         case .right:
             if self.direction == .left {
                 return [Laser(direction: .down)]
             } else if self.direction == .up {
                 return [Laser(direction: .up)]
             } else {
                 return []
             }
         default:
             return []
         }
     }
}
    
 

