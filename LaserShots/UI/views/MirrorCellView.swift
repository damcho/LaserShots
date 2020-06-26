//
//  MirrorView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit
import LaserShotsGameCore

class MirrorCellView: RotatableCellView {
    
    @IBOutlet weak var mirrorView: UIView!
    
    override func setupView() {
        super.setupView()
        self.mirrorView.transform = CGAffineTransform(rotationAngle: -.pi / 4)
    }
}
