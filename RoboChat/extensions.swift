//
//  extensions.swift
//  RoboChat
//
//  Created by Daniel Karath on 1/9/23.
//

import UIKit

extension UIView {
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}
