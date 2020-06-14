//
//  LaserGun.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class LaserGun: ReflectableGameElement {
    public var x: Int
    public var y: Int
    public var direction: PointingDirection = .none
    
    public init(direction: PointingDirection, x: Int = 0, y: Int = 0) {
        self.direction = direction
        self.x = x
        self.y = y
    }
    
    func shoot() -> PointingDirection {
        return self.direction
    }
    
    public func reflect(direction: PointingDirection) -> [PointingDirection] {
        return []
    }
}
