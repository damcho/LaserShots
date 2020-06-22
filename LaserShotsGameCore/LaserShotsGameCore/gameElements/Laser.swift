//
//  Laser.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

final class Laser: Directionable {
    var direction: PointingDirection
    var reflectingDirections: [PointingDirection]
    
    init(direction: PointingDirection, reflectingDirections: [PointingDirection]) {
        self.direction = direction
        self.reflectingDirections = reflectingDirections
    }
}
