//
//  LaserShotsBaseCellView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class LaserShotsBaseCellView: UICollectionViewCell, NibInstantiatable {

    @IBOutlet weak var gameElementContainerView: UIView?
    
    var gameCell:BoardCell? {
        didSet {
            self.setupView()
        }
    }
    
    func setupView() {
        self.rotate()
    }
    
    func rotate() {
        guard let rotationRadians = gameCell?.rotation() else {
            return
        }

        self.gameElementContainerView?.transform = CGAffineTransform(rotationAngle: CGFloat(rotationRadians))
    }
}
