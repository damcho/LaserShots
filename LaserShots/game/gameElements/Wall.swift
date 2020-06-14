//
//  Wall.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

struct Wall: Reflectable {    
    func reflect(direction: PointingDirection) -> [PointingDirection] {
        return [.none]
    }
}
