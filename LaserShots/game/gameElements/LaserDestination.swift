//
//  LaserDestination.swift
//  LaserShots
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation


public final class LaserDestination:GameElement{
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
        return []
    }
    
}
