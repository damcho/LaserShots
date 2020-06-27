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
        UIView.animate(withDuration: 0.15, animations: { () -> Void in
            self.gameElementView.transform = self.gameElementView.transform.rotated(by:  .pi / 2)
        }) {[weak self] (succeed) -> Void in
            self?.gameCellViewModel?.onTap()
        }
    }
    
    func setupInitialDirection(){
        self.gameElementView.transform = .identity
        
        if let viewModel = gameCellViewModel{
            var radiansToRotate:CGFloat
            switch viewModel.direction() {
            case .left:
                radiansToRotate = .pi/4
            case .right:
                radiansToRotate = .pi * 5/4
            case .up:
                radiansToRotate = .pi * 3/4
            default:
                radiansToRotate = .pi/4
            }
            self.gameElementView.transform = CGAffineTransform( rotationAngle: radiansToRotate)
        }
    }
}
