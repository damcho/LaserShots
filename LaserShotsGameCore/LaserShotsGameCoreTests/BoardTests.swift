//
//  BoardTests.swift
//  LaserShotsGameCoreTests
//
//  Created by Damian Modernell on 6/21/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import XCTest
@testable import LaserShotsGameCore
class BoardTests: XCTestCase {
    
    func test_boardIsNilOnInvalidArguments() {
        XCTAssertNil(Board(width: 0, height: 0, elements: []))
        XCTAssertNil(Board(width: 0, height: 1, elements: []))
        XCTAssertNil(Board(width: 1, height: 0, elements: []))
        XCTAssertNil(Board(width: -1, height: 1, elements: []))
        XCTAssertNil(Board(width: 1, height: -1, elements: []))
        XCTAssertNil(Board(width: -1, height: -1, elements: []))
    }
    
    func test_boardIsEmptyWhenGameElementsIsEmpty() {
        let (board, _) = makeSUT(width: 3, height: 3, elements: [])
        
        board.boardCells.forEach { (boardCellsArray) in
            let gameElementsList = boardCellsArray.filter({ (boardCell) -> Bool in
                if let element = boardCell.gameElement {
                    return !(element is Wall)
                }
                return false
            })
            XCTAssertTrue(gameElementsList.isEmpty)
        }
    }
    
    func test_BoardIsCreatedWithElements() {
        let laserGunWrapper = GameElementWrapper(x: 1, y: 1, gameElement: LaserGun(direction: .down))
        let laserDestinationWrapper = GameElementWrapper(x: 2, y: 2, gameElement: LaserDestination(direction: .down))
        let (board, _) = makeSUT(width: 3, height: 3, elements: [laserGunWrapper, laserDestinationWrapper])
        XCTAssertTrue(board.boardCells[1][1].gameElement is LaserGun)
        XCTAssertTrue(board.boardCells[2][2].gameElement is LaserDestination)
    }
    
    func test_LaserShotStart() {
        let laserGunWrapper = GameElementWrapper(x: 1, y: 0, gameElement: LaserGun(direction: .down))
        let (board, _) = makeSUT(width: 3, height: 3, elements: [laserGunWrapper])
        let expectedBoardCellsReflecting = [board.boardCells[1][0],board.boardCells[1][1], board.boardCells[1][2], board.boardCells[1][3]]
                
        expectReflectingCells(expectedBoardCellsReflecting, for: board, when: {
            board.shootLaser()
        })
    }
    
    func test_boardClearedAndReDrawedLaserAfterElementRotation() {
        let laserGunWrapper = GameElementWrapper(x: 1, y: 0, gameElement: LaserGun(direction: .down))
        let mirrorWrapper = GameElementWrapper(x: 1, y: 2, gameElement: Mirror(direction: .up))
        
        let (board, _) = makeSUT(width: 3, height: 3, elements: [laserGunWrapper, mirrorWrapper])
        
        let expectedBoardCellsReflecting = [board.boardCells[1][0],board.boardCells[1][1], board.boardCells[1][2], board.boardCells[2][2], board.boardCells[3][2]]
        
        expectReflectingCells(expectedBoardCellsReflecting, for: board, when: {
            board.shootLaser()
            board.boardCells[1][2].rotateElement()
        })
    }
    
    func test_LevelLostOnLaserTrapHit() {
        let laserGunWrapper = GameElementWrapper(x: 1, y: 0, gameElement: LaserGun(direction: .down))
        let laserTrapWrapper = GameElementWrapper(x: 1, y: 2, gameElement: LaserTrap())
        
        let (board, boardDelegate) = makeSUT(width: 3, height: 3, elements: [laserGunWrapper, laserTrapWrapper])
        expectLevelState(.levelLost, for: boardDelegate, when: {
            board.shootLaser()
        })
    }
    
    func test_levelWonOnLaserDestinationHit() {
        let laserGunWrapper = GameElementWrapper(x: 1, y: 0, gameElement: LaserGun(direction: .down))
        let laserTrapWrapper = GameElementWrapper(x: 1, y: 2, gameElement: LaserDestination(direction: .up))
        
        let (board, boardDelegate) = makeSUT(width: 3, height: 3, elements: [laserGunWrapper, laserTrapWrapper])
        expectLevelState(.levelPassed, for: boardDelegate, when: {
            board.shootLaser()
        })
    }
    
    //Helper
    private func makeSUT(width: Int, height: Int, elements: [GameElementWrapper]) -> (Board, BoardDelegateSpy) {
        let board = Board(width: width, height: height, elements: elements)
        let boardDelegate = BoardDelegateSpy()
        board?.onLevelStateChanged = boardDelegate.onLevelStateChanged
        XCTAssertNotNil(board)
        return (board!, boardDelegate)
    }
    
    private func expectLevelState(_ state: LevelState, for delegate: BoardDelegateSpy, when action: () -> Void, file: StaticString = #file, line: UInt = #line ) {
        action()
        
        XCTAssertEqual([state], delegate.levelStates, file: file, line: line)
    }
    
    private func expectReflectingCells(_ expectedCells: [BoardCell], for board: Board, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var boardCellsReflectingLaser: [BoardCell] = []
        
        action()
        
        board.boardCells.forEach { (boardCellsArray) in
            boardCellsReflectingLaser.append (contentsOf: boardCellsArray.filter({ (boardCell) -> Bool in
                return boardCell.isReflecting()
            }))
        }
        
        XCTAssertEqual(boardCellsReflectingLaser, expectedCells)
    }
}

private class BoardDelegateSpy {
    var levelStates: [LevelState]?
    
    var onLevelStateChanged: ((LevelState) -> Void)?
    
    init() {
        self.levelStates = []
        self.onLevelStateChanged = { [weak self](state: LevelState) in
            self?.levelStates?.append(state)
        }
    }
}
