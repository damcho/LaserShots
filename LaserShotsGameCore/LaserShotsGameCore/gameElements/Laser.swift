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
    
    init(direction: PointingDirection) {
        self.direction = direction
    }
}
