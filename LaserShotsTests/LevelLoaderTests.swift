//
//  LevelLoaderTests.swift
//  LaserShotsTests
//
//  Created by Damian Modernell on 6/10/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import XCTest
import LaserShots

class LevelLoaderTests: XCTestCase {
    
    func test_levelLoader_reuturnsErrorOnLevelLoaderError() {
        let (sut, loaderClient) = makeSUT()
        
        expectErrorFor(sut: sut, when: {
            loaderClient.completeWithError(.unknownError)
        })
    }
    
    func test_returnsInvalidDataErrorOnInvalidJSONLevel() {
        let (sut, loaderClient) = makeSUT()
        
        expectErrorFor(sut: sut, when: {
            let invalidLevelData = Data("invalidLevelJSON".utf8)
            loaderClient.completeWithData(data: invalidLevelData)
        })
    }
    
    func test_returnsEmptyBoardOnEmptyGameElementsLevel() {
        let (sut, loaderClient) = makeSUT()
        let (emptyBoard, emptyBoardJSON) = makeBoard(width: 2, height: 1, elements: [])

        expectSuccessFor(sut: sut, toCompleteWith: emptyBoard , when: {
            let levelData = try! JSONSerialization.data(withJSONObject: emptyBoardJSON)
            loaderClient.completeWithData(data: levelData)
        })
    }
    
    func test_returnsBoardWithValidGameElementsOnly() {
        let (sut, loaderClient) = makeSUT()
        let (laserGun1, laserJSON1) = makeGameElement("laserGun", xPos: 0, yPos: 0, pointing: "down")
        let invalidLaserGun2JSON = ["type": "laserGun", "x": 1, "y": 1,"direction": "wrong direction"] as [String : Any]
        let (modelBoard, JSONBoardWithInvalidGameElement) = makeBoard(width: 2, height: 1, elements: [(laserGun1, laserJSON1), (nil, invalidLaserGun2JSON)])
        let levelData = try! JSONSerialization.data(withJSONObject: JSONBoardWithInvalidGameElement)

        expectSuccessFor(sut: sut, toCompleteWith: modelBoard, when: {
            loaderClient.completeWithData(data: levelData)
        })
    }
    
    func test_returnsValidBoardWithValidJSONBoard() {
        let (sut, loaderClient) = makeSUT()
        let (laserGun1, laserJSON1) = makeGameElement("laserGun", xPos: 0, yPos: 0, pointing: "down")
        let (mirror1, mirrorJSON1) = makeGameElement("mirror", xPos: 1, yPos: 1, pointing: "left")
        let (modelBoard, JSONBoard) = makeBoard(width: 2, height: 1, elements: [(laserGun1, laserJSON1), (mirror1, mirrorJSON1)])
        let levelData = try! JSONSerialization.data(withJSONObject: JSONBoard)
        
        expectSuccessFor(sut: sut, toCompleteWith: modelBoard, when: {
            loaderClient.completeWithData(data: levelData)
        })
    }
    
    
    //Helpers
    private func makeSUT() -> (LaserShotsLevelLoader, BundleLevelLoaderSpy) {
        let loaderClient = BundleLevelLoaderSpy()
        let sut = LevelLoader(client: loaderClient)
        return (sut, loaderClient)
    }
    
    private func makeGameElement(_ type: String, xPos: Int, yPos: Int, pointing: String) -> (GameElementWrapper, [String: Any]) {
        let gameElementJSON = ["type": type, "x": xPos, "y": yPos,"direction": pointing] as [String : Any]
        
        let elementDirection = PointingDirection(rawValue: pointing)!
        let elementType = CellType(rawValue: type)!
        let gameElementWrapper: GameElementWrapper
        switch elementType {
        case .laserGun:
            gameElementWrapper = GameElementWrapper(x: xPos, y: yPos, gameElement: LaserGun(direction: elementDirection))
        case .laserDestination:
            gameElementWrapper = GameElementWrapper(x: xPos, y: yPos, gameElement: LaserDestination(direction: elementDirection))
        case .laserTrap:
            gameElementWrapper = GameElementWrapper(x: xPos, y: yPos, gameElement: LaserTrap())
        case .mirror:
            gameElementWrapper = GameElementWrapper(x: xPos, y: yPos, gameElement: Mirror(direction: elementDirection))
        case .transparentMirror:
            gameElementWrapper = GameElementWrapper(x: xPos, y: yPos, gameElement: TransparentMirror(direction: elementDirection))
        default:
            gameElementWrapper = GameElementWrapper(x: xPos, y: yPos, gameElement: LaserGun(direction: elementDirection))
        }
        return (gameElementWrapper, gameElementJSON)
    }
    
    private func makeBoard(width: Int, height: Int, elements: [(modelElements: GameElementWrapper?, JSONElements: [String: Any])]) -> (Board, [String: Any]){
        let board = Board(width: width, height: height, elements: elements.compactMap({ $0.modelElements }))
        let JSONBoard = ["width": width, "height": height, "gameElements": elements.map({ $0.JSONElements })] as [String : Any]
        return (board, JSONBoard)
    }
    
    private func expectErrorFor(sut: LaserShotsLevelLoader, when action: () -> Void , file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "expect received error")
        
        sut.loadBoard(name: "level1", completion: {resullt in
            switch resullt {
            case .failure(let error):
                XCTAssertNotNil(error, file: file, line: line)
            default:
                XCTFail("expected failure but got success instead", file: file, line: line)
            }
            exp.fulfill()
        })
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expectSuccessFor(sut: LaserShotsLevelLoader, toCompleteWith expectedBoard: Board, when action: () -> Void , file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "expect results")
        
        sut.loadBoard(name: "level1", completion: {result in
            switch result {
            case .success(let receivedBoard):
                XCTAssertEqual(expectedBoard.boardCells.count , receivedBoard.boardCells.count, file: file, line: line)
                expectedBoard.boardCells.enumerated().forEach { (i, expectedBoardCellsRow) in
                    expectedBoardCellsRow.enumerated().forEach { (j, expectedBoardCell) in
                        XCTAssertEqual(expectedBoardCell , receivedBoard.boardCells[i][j], file: file, line: line)
                    }

                }
            default:
                XCTFail("expected success but got failure instead", file: file, line: line)
            }
            exp.fulfill()
        })
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
}


private class BundleLevelLoaderSpy: LevelLoaderClient {
    var messages: [(BundleLevelLoaderResult) -> Void] = []
    
    func loadLevel(name: String, completion: @escaping LevelLoaderClientCompletion) {
        messages.append(completion)
    }
    
    func completeWithError(_ error: BundleLoaderError, at index: Int = 0) {
        if !messages.isEmpty {
            messages[index](.failure(.invalidData))
        }
    }
    
    func completeWithData(data: Data, at index: Int = 0) {
        if !messages.isEmpty {
            messages[index](.success(data))
        }
    }
}
