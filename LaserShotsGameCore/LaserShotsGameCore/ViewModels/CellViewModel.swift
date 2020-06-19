//
//  CellViewModel.swift
//  LaserShots
//
//  Created by Damian Modernell on 6/15/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

public final class CellViewModel {
    private let boardCell: BoardCell
    public var cellViewName: String {
        return boardCell.gameElement == nil ? "EmptyCellView" : String( describing: type(of: boardCell.gameElement.self!)) + "CellView"
    }
    
    init(boardCell: BoardCell) {
        self.boardCell = boardCell
    }
    
    public var onLaserBeamChanged: ((PointingDirection, [PointingDirection]) -> Void)? {
        didSet {
            boardCell.onLaserBeamChanged = self.onLaserBeamChanged
        }
    }
    
    public func direction() -> PointingDirection {
        return boardCell.getDirection()
    }
    
    public func isReflecting() -> Bool {
        return boardCell.isReflecting()
    }
    
    public func onTap() {
        boardCell.performAction()
    }
}
