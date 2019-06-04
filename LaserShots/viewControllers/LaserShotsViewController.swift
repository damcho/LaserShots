//
//  ViewController.swift
//  LaserShots
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class LaserShotsViewController: UIViewController, laserShotsDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var gameBoard: UICollectionView!
    @IBOutlet weak var laserShotsBoard: UIView!
    var laserShotGame:LaserShotsGame?
    var boardCells:[BoardCell] = []
    var cellsPerRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameBoard.isUserInteractionEnabled = false
        
        self.gameBoard.register(UINib(nibName: LaserGunCellView.nibName() ,bundle: nil), forCellWithReuseIdentifier: "LaserGunCellView")
        self.gameBoard.register(UINib(nibName: LaserDestinationCellView.nibName(), bundle: nil), forCellWithReuseIdentifier: "LaserDestinationCellView")
        self.gameBoard.register(UINib(nibName: MirrorCellView.nibName(), bundle: nil), forCellWithReuseIdentifier: "MirrorCellView")
        self.gameBoard.register(UINib(nibName: WallCellView.nibName(), bundle: nil), forCellWithReuseIdentifier: "WallCellView")
        self.gameBoard.register(UINib(nibName: EmptyCellView.nibName(), bundle: nil), forCellWithReuseIdentifier: "EmptyCellView")
        self.gameBoard.register(UINib(nibName: LaserTrapCellView.nibName(), bundle: nil), forCellWithReuseIdentifier: "LaserTrapCellView")
        self.gameBoard.register(UINib(nibName: TransparentMirrorCellView.nibName(), bundle: nil), forCellWithReuseIdentifier: "TransparentMirrorCellView")

        
        
        self.laserShotGame = LaserShotsGame()
        self.laserShotGame?.delegate = self
        self.createBoardGame()
    }
    
    func createBoardGame() {
        let boardCells = self.laserShotGame!.boardCells()
        cellsPerRow = boardCells[0].count
        for cellsArray in boardCells {
            for cell in cellsArray {
                self.boardCells.append(cell)
            }
        }
    }
    
    func gameState(state: gameState) {
        switch state {
        case .gameWon:
            self.showAlert(title: "YEAHH", msg: "You won")
        case .gameLost:
            self.showAlert(title: "Upss", msg: "You Lost")
        default:
            return
        }
    }
    
    func showAlert(title:String, msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.boardCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let boardCell = self.boardCells[indexPath.row]
        var cellView:LaserShotsBaseCellView
        var reuseIdentifier:String
        switch boardCell.cellType {
        case .Empty:
            reuseIdentifier = "EmptyCellView"
        case .LaserDestination:
            reuseIdentifier = "LaserDestinationCellView"
        case .LaserGun:
            reuseIdentifier = "LaserGunCellView"
        case .Mirror:
            reuseIdentifier = "MirrorCellView"
        case .Wall:
            reuseIdentifier = "WallCellView"
        case .LaserTrap:
            reuseIdentifier = "LaserTrapCellView"
        case .TransparentMirror:
            reuseIdentifier = "TransparentMirrorCellView"
        }
        cellView = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LaserShotsBaseCellView

        cellView.gameCell = boardCell
        cellView.layoutIfNeeded()

        return cellView
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let availableWidth = self.gameBoard.frame.width
        let widthPerItem = availableWidth.rounded() / CGFloat(cellsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    @IBAction func onStartButtonTapped(_ sender: Any) {
        self.laserShotGame?.start()
        self.gameBoard.isUserInteractionEnabled = true
    }
    
}

