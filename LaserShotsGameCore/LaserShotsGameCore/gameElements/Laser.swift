//
//  Laser.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class Laser: Directionable {
    public var direction: PointingDirection
    
    public init(direction: PointingDirection) {
        self.direction = direction
    }
}
