//
//  BundleLevelLoaderTests.swift
//  LaserShotsGameCoreTests
//
//  Created by Damian Modernell on 6/25/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import XCTest
import LaserShotsGameCore

class BundleLevelLoaderTests: XCTestCase {
    
    func test_deliversErrorOnInvalidPath() {
        let (sut, bundle) = makeSUT()
        
        expectError(.invalidPath, for: sut, when: {
            bundle.setInvalidPath()
        })
    }
    
    func test_DeliversInvalidDataErrorOnInvalidData() {
        let (sut, bundle) = makeSUT()
        
        expectError(.invalidData, for: sut, when: {
            bundle.setValidResourcePath()
        })
    }
    
    //Helpers
    private func makeSUT() -> (LevelLoaderClient, bundleMock)  {
        let bundle = bundleMock()
        return (BundleJSONLevelLoaderClient(bundle: bundle), bundle)
    }
    
    private func expectError(_ expectedError: BundleLoaderError, for loader: LevelLoaderClient, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        action()
        
        loader.loadLevel(name: "some name") { (BundleLevelLoaderResult) in
            switch BundleLevelLoaderResult {
            case .failure(let error):
                XCTAssertEqual(error, expectedError, file: file, line: line)
            default:
                XCTFail()
            }
        }
    }
}

private class bundleMock: Bundle {
    var path: String?
    override func path(forResource name: String?, ofType ext: String?) -> String? {
        return path
    }
    
    func setInvalidPath() {
        path = nil
    }
    
    func setValidResourcePath() {
        path = "some valid path"
    }
}
