//
//  Wall.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class Wall: Reflectable {
    var direction: PointingDirection = .none
    
    func reflect(direction: PointingDirection) -> [PointingDirection] {
        return [self.direction]
    }
}
