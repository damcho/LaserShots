//
//  ViewController.swift
//  LaserShots
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class LaserShotsViewController: UIViewController, laserShotsDelegate {

    @IBOutlet weak var laserShotsGameBoard: UICollectionView!
    @IBOutlet weak var laserShotsBoard: UIView!
    var laserShotGame:LaserShotsGame?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.laserShotGame = LaserShotsGame()
    //    self.laserShotGame?.delegate = self
        self.createBoardGame()
        self.laserShotGame?.start()
    }
    
    func createBoardGame() {
        let boardCells = self.laserShotGame!.boardCells()
        let cellWidth = self.laserShotsBoard.frame.size.width / CGFloat(boardCells.count)
        let cellHeight = self.laserShotsBoard.frame.size.height /  CGFloat(boardCells[0].count)

        for (iIndex, cellsArray) in boardCells.enumerated() {

            for (jIndex, cell) in cellsArray.enumerated() {
                let cellView:LaserShotsBaseCellView?
                switch cell.cellType {
                case .Empty:
                    cellView = EmptyCellView.fromNib()
                case .LaserDestination:
                    cellView = LaserDestinationCellView.fromNib()
                case .LaserGun:
                    cellView = LaserGunCellView.fromNib()
                case .Mirror:
                    cellView = MirrorCellView.fromNib()
                case .Wall:
                    cellView = WallCellView.fromNib()
                }
                cellView?.frame = CGRect(x: CGFloat( iIndex) * cellWidth, y: CGFloat(jIndex) * cellHeight, width: cellWidth, height: cellHeight)
                
                cellView?.gameCell = cell
                self.laserShotsBoard.addSubview(cellView!)
            }
        }
    }
    
    func gameState(state: gameState) {
        switch state {
        case .gameWon:
            let alert = UIAlertController(title: "YEAH!", message: "You Won!!!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .gameLost:
            let alert = UIAlertController(title: "Upss!", message: "You Lost!!!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        default:
            return
        }
    }
}

