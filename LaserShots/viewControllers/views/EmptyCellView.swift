//
//  EmptyCellView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class EmptyCellView: LaserShotsBaseCellView {

    @IBOutlet weak var horizontalLaserView: UIView!
    @IBOutlet weak var verticalLaserView: UIView!
    
    override func setupView() {
        self.gameCell?.onLaserHit = { () -> () in
            self.horizontalLaserView.isHidden = self.gameCell?.horizontalBeam == nil
            self.verticalLaserView.isHidden = self.gameCell?.verticalBeam == nil
        }
    }
    
    override func awakeFromNib() {
        self.horizontalLaserView.isHidden = true
        self.verticalLaserView.isHidden = true
    }
}
