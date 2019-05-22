//
//  MirrorView.swift
//  LaserShots
//
//  Created by Damian Modernell on 22/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class MirrorCellView: LaserShotsBaseCellView {

  
    @IBOutlet weak var mirrorView: UIView!
    
    override func awakeFromNib() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
        self.mirrorView.transform = CGAffineTransform(rotationAngle: .pi / 4)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.mirrorView.transform = self.mirrorView.transform.rotated(by:  .pi / 2)

    }

}
