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
        guard let board = Board(width: 2, height: 2, elements: []) else {
            XCTFail()
            return
        }
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
    
    
    //Helper
    

}
