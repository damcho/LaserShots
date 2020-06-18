//
//  ViewController+extensions.swift
//  LaserShots
//
//  Created by Damian Modernell on 6/18/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    static func loadFromStoryboard() -> UIViewController?{
        let bundle = Bundle(for: self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self))
        return vc
    }
}
