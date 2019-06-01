//
//  TransparentMirrorCellView.swift
//  LaserShots
//
//  Created by Damian Modernell on 01/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class TransparentMirrorCellView: LaserShotsBaseCellView {

    @IBOutlet weak var transparentMirrorView: UIView!
    @IBOutlet weak var LaserBeam1View: UIView!
    @IBOutlet weak var LaserBeam2View: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
        self.transparentMirrorView.transform = CGAffineTransform(rotationAngle: -.pi / 4)
        self.LaserBeam1View.isHidden = true
        self.LaserBeam2View.isHidden = true
    }
    
    override func setupView() {
        super.setupView()
        self.gameCell?.onLaserBeamChanged = { () -> () in
            let shouldhideBeams = self.gameCell?.horizontalBeam == nil && self.gameCell?.verticalBeam == nil
            self.LaserBeam1View.isHidden = shouldhideBeams
            self.LaserBeam2View.isHidden = shouldhideBeams
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let rotatingView = self.gameElementContainerView else {
            return
        }
        rotatingView.transform = rotatingView.transform.rotated(by:  .pi / 2)
        self.gameCell?.onTap()
    }

}
