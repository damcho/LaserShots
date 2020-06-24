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
        let board = makeSUT(width: 3, height: 3, elements: [])
        
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
        let board = makeSUT(width: 3, height: 3, elements: [laserGunWrapper, laserDestinationWrapper])
        XCTAssertTrue(board.boardCells[1][1].gameElement is LaserGun)
        XCTAssertTrue(board.boardCells[2][2].gameElement is LaserDestination)
    }
    
    func test_LaserShotStart() {
        let laserGunWrapper = GameElementWrapper(x: 1, y: 0, gameElement: LaserGun(direction: .down))
        var boardCellsReflectingLaser: [BoardCell] = []
        let board = makeSUT(width: 3, height: 3, elements: [laserGunWrapper])
        let expectedBoardCellsReflecting = [board.boardCells[1][0],board.boardCells[1][1], board.boardCells[1][2], board.boardCells[1][3]]
        
        board.shootLaser()
        
        board.boardCells.forEach { (boardCellsArray) in
            boardCellsReflectingLaser.append (contentsOf: boardCellsArray.filter({ (boardCell) -> Bool in
                return boardCell.isReflecting()
            }))
        }
        
        XCTAssertEqual(boardCellsReflectingLaser, expectedBoardCellsReflecting)
    }
    
    func test_boardClearedAfterCellAction() {
        let laserGunWrapper = GameElementWrapper(x: 1, y: 0, gameElement: LaserGun(direction: .down))
        let mirrorWrapper = GameElementWrapper(x: 1, y: 2, gameElement: Mirror(direction: .up))
        
        var boardCellsReflectingLaser: [BoardCell] = []
        let board = makeSUT(width: 3, height: 3, elements: [laserGunWrapper, mirrorWrapper])
        
        let expectedBoardCellsReflecting = [board.boardCells[1][0],board.boardCells[1][1], board.boardCells[1][2], board.boardCells[2][2], board.boardCells[3][2]]
        
        board.shootLaser()
        
        board.boardCells[1][2].rotateElement()
        
        board.boardCells.forEach { (boardCellsArray) in
            boardCellsReflectingLaser.append (contentsOf: boardCellsArray.filter({ (boardCell) -> Bool in
                return boardCell.isReflecting()
            }))
        }
        
        XCTAssertEqual(boardCellsReflectingLaser, expectedBoardCellsReflecting)
        
    }
    
    
    //Helper
    private func makeSUT(width: Int, height: Int, elements: [GameElementWrapper]) -> Board {
        let board = Board(width: width, height: height, elements: elements)
        XCTAssertNotNil(board)
        return board!
    }
}
