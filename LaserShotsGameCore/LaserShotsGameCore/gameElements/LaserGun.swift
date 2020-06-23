//
//  LaserGun.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class LaserGun: GameElement, Directionable {
    public var direction: PointingDirection
    
    public init(direction: PointingDirection) {
        self.direction = direction
    }
}

extension LaserGun: Shooter {
    public func shoot() -> Laser {
        return Laser(direction: self.direction)
    }
}
