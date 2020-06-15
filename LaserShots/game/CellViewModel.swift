//
//  CellViewModel.swift
//  LaserShots
//
//  Created by Damian Modernell on 6/15/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

final class CellViewModel {
    let boardCell: BoardCell
    var cellViewName: String {
        return boardCell.gameElement == nil ? "EmptyCellView" : String( describing: type(of: boardCell.gameElement.self!)) + "CellView"
    }
    
    init(boardCell: BoardCell) {
        self.boardCell = boardCell
    }
    
    var onLaserBeamChanged: ((PointingDirection, [PointingDirection]) -> Void)? {
        didSet {
            boardCell.onLaserBeamChanged = self.onLaserBeamChanged
        }
    }
    
    func direction() -> PointingDirection {
        return boardCell.getDirection()
    }
    
    func isReflecting() -> Bool {
        return boardCell.isReflecting()
    }
    
    func onTap() {
        boardCell.onTap()
    }
}
