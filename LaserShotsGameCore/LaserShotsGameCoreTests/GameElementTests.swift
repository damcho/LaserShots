//
//  GameElementsTests.swift
//  LaserShotsGameCoreTests
//
//  Created by Damian Modernell on 6/24/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import XCTest
import LaserShotsGameCore

class GameElementTests: XCTestCase {
    
    func test_MirrorRotation() {
        let mirror = Mirror(direction: .down)
        mirror.rotate()
        XCTAssertEqual(mirror.direction, .left)
        mirror.rotate()
        XCTAssertEqual(mirror.direction, .up)
        mirror.rotate()
        XCTAssertEqual(mirror.direction, .right)
        mirror.rotate()
        XCTAssertEqual(mirror.direction, .down)
    }
    
    
    func test_MirrorReflection() {
        let mirror = Mirror(direction: .down)
        let laser = Laser(direction: .down)
        
        expect(expectedReflectionDirections: [], for: mirror, hitby: laser, when: { })
        
        expect(expectedReflectionDirections: [], for: mirror, hitby: laser, when: {
            mirror.rotate()
        })
        
        expect(expectedReflectionDirections: [.left], for: mirror, hitby: laser, when: {
            mirror.rotate()
        })
        
        expect(expectedReflectionDirections: [.right], for: mirror, hitby: laser, when: {
            mirror.rotate()
        })
    }
    
    func test_TransparentMirrorReflections() {
        let mirror = TransparentMirror(direction: .down)
        let laser = Laser(direction: .down)
        
        expect(expectedReflectionDirections: [], for: mirror, hitby: laser, when: { })
        
        expect(expectedReflectionDirections: [], for: mirror, hitby: laser, when: {
            mirror.rotate()
        })
        
        expect(expectedReflectionDirections: [.left, .down], for: mirror, hitby: laser, when: {
            mirror.rotate()
        })
        
        expect(expectedReflectionDirections: [.right, .down], for: mirror, hitby: laser, when: {
            mirror.rotate()
        })
    }
    
    func test_LaserDestinationCreation() {
        let destination = LaserDestination(direction: .down)
        XCTAssertTrue(destination.direction == .down)
    }
    
    func test_laserGun() {
        let laserGun = LaserGun(direction: .down)
        let laser = laserGun.shoot()
        XCTAssertTrue(laser.direction == .down)
    }
    
    //Helpers
    
    private func expect(expectedReflectionDirections: [PointingDirection], for reflectable: Reflectable, hitby laser: Laser, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        action()
        
        let reflectedDirections = reflectable.reflect(laser).map ({ (Laser)  in
            Laser.direction
        })
        
        XCTAssertEqual(expectedReflectionDirections, reflectedDirections, file: file, line: line)
    }
    
}
