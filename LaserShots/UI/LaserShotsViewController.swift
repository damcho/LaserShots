//
//  ViewController.swift
//  LaserShots
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit
import LaserShotsGameCore

final class LaserShotsViewController: UIViewController {
    
    @IBOutlet weak var gameBoard: UICollectionView!
    
    private var boardCells: [CellViewModel] = []
    private var cellsPerRow = 0
    var laserShotsGameViewModel: LaserGameViewModel?
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameBoard.isUserInteractionEnabled = false
        registerNibs()
        bind()
        laserShotsGameViewModel?.nextLevel()
    }
    
    private func bind() {
        self.laserShotsGameViewModel?.onBoardLoaded = { [weak self] (cells, cellsPerRow) in
            self?.boardCells = cells
            self?.cellsPerRow = cellsPerRow
            self?.gameBoard.reloadData()
            self?.gameBoard.isUserInteractionEnabled = false
        }
        
        self.laserShotsGameViewModel?.onGameStateChanged = { [weak self] (alertViewModel) in
            var action:(UIAlertAction) -> Void
            
            switch alertViewModel.state {
            case .gameLost:
                action = {[weak self](action:UIAlertAction) ->() in
                    self?.laserShotsGameViewModel?.restartLevel()
                }
            case.gameWon:
                action = {[weak self](action:UIAlertAction) ->() in
                    self?.navigationController?.popViewController(animated: true)
                }
            case.nextLevel:
                action = {[weak self](action:UIAlertAction) ->() in
                    self?.animateLevelTransition()
                }
            }
            
            self?.showAlert(title: alertViewModel.titleText, msg: alertViewModel.alertMsgText, action: UIAlertAction(title:alertViewModel.actionTitleTText , style: .default, handler:action))
        }
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
    
    private func animateLevelTransition() {
        UIView.animate(withDuration: 1, animations: {[weak self] () -> Void in
            self?.gameBoard.alpha = 0
        }) {[weak self] (succeed) -> Void in
            self?.laserShotsGameViewModel?.nextLevel()
            UIView.animate(withDuration: 1, animations: {[weak self] () -> Void in
                self?.gameBoard.alpha = 1
            })
        }
    }
    
    func showAlert(title:String, msg:String, action:UIAlertAction) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onStartButtonTapped(_ sender: Any) {
        self.laserShotsGameViewModel?.start()
        self.gameBoard.isUserInteractionEnabled = true
    }
}

extension LaserShotsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.boardCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let boardCellViewModel = self.boardCells[indexPath.row]
        let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: boardCellViewModel.cellViewName, for: indexPath) as! LaserShotsBaseCellView
        cellView.gameCellViewModel = boardCellViewModel
        return cellView
    }
}

extension LaserShotsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = self.gameBoard.frame.width
        let widthPerItem = availableWidth.rounded() / CGFloat(cellsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}


