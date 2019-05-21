//
//  Laser.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class Laser: GameElement {
    var hasLaserBeam = true
    var direction: flipDirection
    
    init(direction:flipDirection) {
        self.direction = direction
    }
}
