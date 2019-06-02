//
//  LaserGun.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class LaserGun: GameElement {
    var direction: pointingDirection
    
    init?(jsonElement:Dictionary<String, Any>) {
        
        guard let direction = jsonElement["direction"] as? String else {
            return nil
        }
        self.direction = pointingDirection(rawValue:direction) ?? .down
    }
    
    func shoot() -> pointingDirection {
        return self.direction
    }
    
    func reflect(direction: pointingDirection) -> [pointingDirection] {
        return []
    }
}
