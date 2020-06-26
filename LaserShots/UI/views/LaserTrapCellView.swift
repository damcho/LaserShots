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
    
    override func setupView() {
        super.setupView()
        self.blackHoleView.layer.cornerRadius = self.blackHoleView.frame.size.width / 2
    }
}
