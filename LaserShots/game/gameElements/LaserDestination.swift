//
//  LaserDestination.swift
//  LaserShots
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation


public final class LaserDestination:GameElement{
    public var direction: pointingDirection
    
    public init(direction: pointingDirection) {
        self.direction = direction
    }
    
    init?(jsonElement:Dictionary<String, Any>) {
        
        guard let direction = jsonElement["direction"] as? String else {
            return nil
        }
        self.direction = pointingDirection(rawValue:direction) ?? .down
    }
    
    public func reflect(direction: pointingDirection) -> [pointingDirection] {
        return []
    }
    
}
