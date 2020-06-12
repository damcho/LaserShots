//
//  LaserGun.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class LaserGun: GameElement {
    public var direction: pointingDirection = .none
    
    public init(direction: pointingDirection) {
        self.direction = direction
    }
    
    public convenience init?(jsonElement:Dictionary<String, Any>) {
        guard let direction = jsonElement["direction"] as? String else {
            return nil
        }
        self.init(direction: pointingDirection(rawValue:direction) ?? .down)
    }
    
    func shoot() -> pointingDirection {
        return self.direction
    }
    
    public func reflect(direction: pointingDirection) -> [pointingDirection] {
        return []
    }
}
