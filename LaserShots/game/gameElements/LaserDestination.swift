//
//  LaserDestination.swift
//  LaserShots
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation


public final class LaserDestination: GameElement{
    public var x: Int
    public var y: Int
    public var direction: PointingDirection
    
    public init(direction: PointingDirection, x: Int, y: Int) {
        self.direction = direction
        self.x = x
        self.y = y
    }
}

extension LaserDestination: Reflectable {
    public func reflect(direction: PointingDirection) -> [PointingDirection] {
        return [.none]
    }
}
