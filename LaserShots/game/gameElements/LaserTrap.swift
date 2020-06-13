//
//  LaserTrap.swift
//  LaserShots
//
//  Created by Damian Modernell on 31/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class LaserTrap: GameElement {
    public var direction = pointingDirection.none
    
    public init(){}
    
    public func reflect(direction: pointingDirection) -> [pointingDirection] {
        return []
    }
}
