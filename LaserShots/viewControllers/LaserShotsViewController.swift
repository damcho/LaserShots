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
        self.registerNibs()
        self.laserShotGame = LaserShotsGame()
        self.laserShotGame?.delegate = self
        self.createBoardGame()
    }
    
    private func registerNibs () {
        self.gameBoard.register(UINib(nibName: LaserGunCellView.nibName() ,bundle: nil), forCellWithReuseIdentifier: "LaserGunCellView")
        self.gameBoard.register(UINib(nibName: LaserDestinationCellView.nibName(), bundle: nil), forCellWithReuseIdentifier: "LaserDestinationCellView")
        self.gameBoard.register(UINib(nibName: MirrorCellView.nibName(), bundle: nil), forCellWithReuseIdentifier: "MirrorCellView")
        self.gameBoard.register(UINib(nibName: WallCellView.nibName(), bundle: nil), forCellWithReuseIdentifier: "WallCellView")
        self.gameBoard.register(UINib(nibName: EmptyCellView.nibName(), bundle: nil), forCellWithReuseIdentifier: "EmptyCellView")
        self.gameBoard.register(UINib(nibName: LaserTrapCellView.nibName(), bundle: nil), forCellWithReuseIdentifier: "LaserTrapCellView")
        self.gameBoard.register(UINib(nibName: TransparentMirrorCellView.nibName(), bundle: nil), forCellWithReuseIdentifier: "TransparentMirrorCellView")
    }
    
    func createBoardGame() {
        self.boardCells = []
        guard let gameBoardCells = self.laserShotGame?.boardCells() else {
            return
        }
        cellsPerRow = gameBoardCells[0].count
        for cellsArray in gameBoardCells {
            for cell in cellsArray {
                self.boardCells.append(cell)
            }
        }
        
    }
    
    func gameState(state: gameState) {
        switch state {
        case .nextLevel:
            let action = UIAlertAction(title: "next level", style: .default, handler: {(action:UIAlertAction) ->() in
                self.laserShotGame?.nextLevel()
            })
            self.showAlert(title: "YEAHH", msg: "You passed to the next level", action: action)
        case .gameWon:
            let action = UIAlertAction(title: "Main screen", style: .default, handler: {(action:UIAlertAction) ->() in
                self.navigationController?.popViewController(animated: true)
            })
            self.showAlert(title: "YEAHH", msg: "You Finished all the levels", action: action)
        case .gameLost:
            let action = UIAlertAction(title: "restart", style: .default, handler: {(action:UIAlertAction) ->() in
                self.laserShotGame?.restart()
            })
            self.showAlert(title: "Upss", msg: "You Lost", action: action)
        }
    }
    
    func levelLoaded() {
        self.createBoardGame()
        self.gameBoard.reloadData()
        self.gameBoard.isUserInteractionEnabled = false
    }
    
    func showAlert(title:String, msg:String, action:UIAlertAction) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(action)
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

