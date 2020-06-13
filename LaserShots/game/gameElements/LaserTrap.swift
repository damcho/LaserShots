//
//  LaserTrap.swift
//  LaserShots
//
//  Created by Damian Modernell on 31/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class LaserTrap: GameElement {
    public var x: Int = -1
    public var y: Int = -1
    public var direction = pointingDirection.none
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    public func reflect(direction: pointingDirection) -> [pointingDirection] {
        return []
    }
}
