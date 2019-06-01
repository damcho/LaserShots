//
//  LaserTrap.swift
//  LaserShots
//
//  Created by Damian Modernell on 31/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class LaserTrap: GameElement {
    var direction = pointingDirection.none
    
    func reflect(direction: pointingDirection) -> pointingDirection {
        return self.direction
    }
}
