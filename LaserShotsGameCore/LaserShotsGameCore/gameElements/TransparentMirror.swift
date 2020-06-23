//
//  TransparentMirror.swift
//  LaserShots
//
//  Created by Damian Modernell on 01/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class TransparentMirror: ReflectableRotatableGameElement {
    public var direction: PointingDirection
    
    public init(direction: PointingDirection) {
        self.direction = direction
    }
}

extension TransparentMirror {
    public func reflect(_ laser: Laser) -> [Laser] {
        switch laser.direction {
        case .down:
            if self.direction == .up {
                return [Laser(direction: .left), Laser(direction: .down)]
            } else if self.direction == .right {
                return [Laser(direction: .right), Laser(direction: .down)]
            } else {
                return []
            }
        case .up:
            if self.direction == .down {
                return [Laser(direction: .right), Laser(direction: .up)]
            } else if self.direction == .left {
                return [Laser(direction: .left), Laser(direction: .up)]
            } else {
                return []
            }
        case .left:
            if self.direction == .right {
                return [Laser(direction: .up), Laser(direction: .left)]
            } else if self.direction == .down {
                return [Laser(direction: .down), Laser(direction: .left)]
            } else {
                return []
            }
        case .right:
            if self.direction == .left {
                return [Laser(direction: .down), Laser(direction: .right)]
            } else if self.direction == .up {
                return [Laser(direction: .up), Laser(direction: .right)]
            } else {
                return []
            }
        default:
            return []
        }
    }
}
