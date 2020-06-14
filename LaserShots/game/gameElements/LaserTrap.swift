//
//  LaserTrap.swift
//  LaserShots
//
//  Created by Damian Modernell on 31/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class LaserTrap: GameElement {
    public var x: Int
    public var y: Int
    public var direction = PointingDirection.none
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension LaserTrap: Reflectable {
    public func reflect(direction: PointingDirection) -> [PointingDirection] {
        return [direction]
    }
}
