//
//  LaserTrapViewCollectionViewCell.swift
//  LaserShots
//
//  Created by Damian Modernell on 31/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit
import LaserShotsGameCore

class LaserTrapCellView: LaserShotsBaseCellView {
    @IBOutlet weak var blackHoleView: UIView!
    @IBOutlet weak var verticalLaser1View: UIView!
    @IBOutlet weak var verticalLaser2View: UIView!
    @IBOutlet weak var horizontalLaser1View: UIView!
    @IBOutlet weak var horizontalLaser2View: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.blackHoleView.layer.cornerRadius = self.blackHoleView.frame.size.width / 2
    }
    
    override func setupView() {
        self.hideLaserBeams()
        self.gameCellViewModel?.onLaserBeamChanged = {[weak self] (direction:PointingDirection, reflections:[PointingDirection]) -> () in
            switch direction {
            case .right:
                self?.horizontalLaser2View.isHidden = false
            case .left:
                self?.horizontalLaser1View.isHidden = false
            case .up:
                self?.verticalLaser1View.isHidden = false
            case .down:
                self?.verticalLaser2View.isHidden = false
            default:
                self?.hideLaserBeams()
            }
        }
    }
    
    private func hideLaserBeams() {
        verticalLaser2View.isHidden = true
        verticalLaser1View.isHidden = true
        horizontalLaser1View.isHidden = true
        horizontalLaser2View.isHidden = true
    }
}
