//
//  LaserDestination.swift
//  LaserShots
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation


public final class LaserDestination: GameElement, Directionable, GameDestination{
    public var direction: PointingDirection
    
    public init(direction: PointingDirection) {
        self.direction = direction
    }
}
