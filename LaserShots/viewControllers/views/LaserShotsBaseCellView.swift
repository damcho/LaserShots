//
//  LaserShotsBaseCellView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class LaserShotsBaseCellView: UIView, NibInstantiatable {

    @IBOutlet weak var gameElementContainerView: UIView!
    
    var gameCell:BoardCell? {
        didSet {
            self.rotate()
        }
    }
    
    private func rotate() {
        guard let rotationRadians = gameCell?.rotation() else {
            return
        }
        self.updateConstraintsIfNeeded()

        self.gameElementContainerView.transform = CGAffineTransform(rotationAngle: CGFloat(rotationRadians))
        self.updateConstraintsIfNeeded()
/*
        if rotationRadians == .pi/2 || rotationRadians == .pi * 3/2 {
            let viewWidth = self.frame.size.width
            let height = self.frame.size.height
            self.frame.size = CGSize(width: height, height: viewWidth)
        }
 */
      
    }
    

}
