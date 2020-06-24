//
//  LaserShotsGameTests.swift
//  LaserShotsGameCoreTests
//
//  Created by Damian Modernell on 6/24/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import XCTest
@testable import LaserShotsGameCore

class LaserShotsGameTests: XCTestCase {

    func test_LaserShotsGameCreationDoesNotLoadLevel() {
        let (_ , loader) = makeSUT()
        XCTAssertFalse(loader.levelLoaded)
    }
    
    func test_loadLevel() {
        let (sut , loader) = makeSUT()
        sut.nextLevel()
        XCTAssertTrue(loader.levelLoaded)
    }
    
    //Helpers
    private func makeSUT() -> (LaserShotsGame, LevelLoaderSpy) {
        let loader = LevelLoaderSpy()
        let sut = LaserShotsGame(levelLoader: loader)
        return (sut, loader)
    }
}

private class LevelLoaderSpy: LaserShotsLevelLoader {
    var levelLoaded: Bool = false
    func loadBoard(name: String, completion: @escaping loaderCompletion) {
        levelLoaded = true
    }
}
