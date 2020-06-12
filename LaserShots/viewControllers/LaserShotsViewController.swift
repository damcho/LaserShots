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
    
    var laserShotGame:LaserShotsGame?
    var boardCells:[BoardCell] = []
    var cellsPerRow = 0
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameBoard.isUserInteractionEnabled = false
        self.registerNibs()
        self.laserShotGame = LaserShotsGame(levelLoader: LevelLoader())
        self.laserShotGame?.delegate = self
        self.laserShotGame?.nextLevel()
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
    
    private func animateLevelTransition() {
        UIView.animate(withDuration: 1, animations: {[weak self] () -> Void in
            self?.gameBoard.alpha = 0
        }) {[weak self] (succeed) -> Void in
            self?.laserShotGame?.nextLevel()
            UIView.animate(withDuration: 1, animations: {[weak self] () -> Void in
                self?.gameBoard.alpha = 1
            })
        }
    }
    
    func gameState(state: gameState) {
        var title:String
        var actionTitle:String
        var msg:String
        var action:(UIAlertAction) -> Void
        switch state {
        case .nextLevel:
            action = {[weak self](action:UIAlertAction) ->() in
                self?.animateLevelTransition()
            }
            actionTitle = "next level"
            msg = "YEAHH"
            title = "You passed to the next level"
        case .gameWon:
            action = {[weak self](action:UIAlertAction) ->() in
                self?.navigationController?.popViewController(animated: true)
            }
            actionTitle = "Main screen"
            msg = "YEAHH"
            title = "You Finished all the levels"
        case .gameLost:
            action = {[weak self](action:UIAlertAction) ->() in
                self?.laserShotGame?.restartLevel()
            }
            actionTitle = "Restart level"
            msg = "You lost"
            title = "Ups"
        }
        
        self.showAlert(title: title, msg: msg, action: UIAlertAction(title:actionTitle , style: .default, handler:action))
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

