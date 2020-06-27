//
//  GameElementCellViewProtocols.swift
//  LaserShots
//
//  Created by Damian Modernell on 6/27/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

protocol DirectionableCell {
    func setupInitialDirection()
}

extension DirectionableCell where Self: LaserShotsBaseCellView{
    func setupInitialDirection(){
        self.gameElementView.transform = .identity

        if let viewModel = gameCellViewModel{
            var radiansToRotate:CGFloat
            switch viewModel.direction() {
            case .left:
                radiansToRotate = .pi/2
            case .right:
                radiansToRotate = .pi * 3/2
            case .up:
                radiansToRotate = .pi
            default:
                radiansToRotate = 0
            }
            self.gameElementView.transform = CGAffineTransform( rotationAngle: radiansToRotate)
        }
    }
}
