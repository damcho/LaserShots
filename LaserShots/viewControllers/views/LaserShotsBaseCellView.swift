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
    
    func rotate(){
        guard let gameElement = self.gameCell else {
            return
        }
        var radiansToRotate:CGFloat
        switch gameElement.getDirection() {
        case .left:
            radiansToRotate = .pi/2
        case .right:
            radiansToRotate = .pi * 3/2
        case .up:
            radiansToRotate = .pi
        default:
            radiansToRotate = 0
        }
        self.gameElementContainerView?.transform = CGAffineTransform(rotationAngle: radiansToRotate)
    }
}
