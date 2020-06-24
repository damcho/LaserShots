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
        let (_ , loader, _) = makeSUT()
        XCTAssertNil(loader.completion)
    }
    
    func test_loadLevelWithError() {
        let (sut , loader, delegate) = makeSUT()
        sut.nextLevel()
        loader.completeLoadingWithError(NSError(domain: "loading error", code: 1))
        
        XCTAssertTrue(delegate.boardCellsMatrixArray.isEmpty)
        
    }
    
    func test_loadLevelSuccessfully() {
        let board = Board(width: 3, height: 3, elements: [])!
        let (sut , loader, delegate) = makeSUT()
        sut.nextLevel()
        
        loader.completeLoadingWithSuccess(board: board)
        
        XCTAssertTrue(delegate.boardCellsMatrixArray.count == 1)
        XCTAssertTrue(delegate.gameStateArray.isEmpty)
    }
    
    func test_gameStateChangesOnGameLost() {
        let board = Board(width: 3, height: 3, elements: [])!
        let (sut , loader, delegate) = makeSUT()
        sut.nextLevel()
        
        expectGameState([.gameLost], for: delegate, when: {
            loader.completeLoadingWithSuccess(board: board)
            board.onLevelStateChanged?(.levelLost)
        })
    }
    
    func test_gameStateNextLevelOnLevelPassed() {
        let board = Board(width: 3, height: 3, elements: [])!
        let (sut , loader, delegate) = makeSUT()
        sut.nextLevel()
        
        expectGameState([.nextLevel], for: delegate, when: {
            loader.completeLoadingWithSuccess(board: board)
            board.onLevelStateChanged?(.levelPassed)
        })
    }
    
    func test_gameStateWonOnAllLevelsPassed() {
        let board = Board(width: 3, height: 3, elements: [])!
        let (sut , loader, delegate) = makeSUT()
        sut.nextLevel()
        
        expectGameState([.nextLevel, .gameWon], for: delegate, when: {
            loader.completeLoadingWithSuccess(board: board)
            board.onLevelStateChanged?(.levelPassed)
            sut.nextLevel()
            board.onLevelStateChanged?(.levelPassed)
        })
    }

    //Helpers
    
    private func expectGameState(_ states: [GameState], for delegate: LaserShotsDelegateSpy, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        action()
        
        XCTAssertEqual(delegate.gameStateArray, states, file: file, line: line)
    }
    
    private func makeSUT() -> (LaserShotsGame, LevelLoaderSpy, LaserShotsDelegateSpy) {
        let loader = LevelLoaderSpy()
        let sut = LaserShotsGame(levelLoader: loader)
        let delegate =  LaserShotsDelegateSpy()
        sut.delegate = delegate
        return (sut, loader, delegate)
    }
}

private class LevelLoaderSpy: LaserShotsLevelLoader {
    var completion: loaderCompletion?
    
    func loadBoard(name: String, completion: @escaping loaderCompletion) {
        self.completion = completion
    }
    
    func completeLoadingWithSuccess(board: Board) {
        completion?(.success(board))
    }
    
    func completeLoadingWithError(_ error: NSError) {
        completion?(.failure(error))
    }
}

private class LaserShotsDelegateSpy: laserShotsDelegate {
    var boardCellsMatrixArray: [[[BoardCell]]] = []
    var gameStateArray: [GameState] = []
    
    func gameStateChanged(state: GameState) {
        self.gameStateArray.append(state)
    }
    
    func levelLoaded(with boardCells: [[BoardCell]]) {
        self.boardCellsMatrixArray.append(boardCells)
    }
}
