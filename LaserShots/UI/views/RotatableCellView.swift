//
//  RotatableCellView.swift
//  LaserShots
//
//  Created by Damian Modernell on 19/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class RotatableCellView : LaserShotsBaseCellView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let rotatingView = self.gameElementContainerView else {
            return
        }
        UIView.animate(withDuration: 0.15, animations: { () -> Void in
            rotatingView.transform = rotatingView.transform.rotated(by:  .pi / 2)
        }) {[weak self] (succeed) -> Void in
            self?.gameCellViewModel?.onTap()
        }
    }
}
