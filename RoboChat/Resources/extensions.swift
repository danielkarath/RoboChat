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
    
    public func circleAnimation(image: UIImageView, borderColor: UIColor, fillColor: UIColor = UIColor.clear, cornerRadious: CGFloat, animationTime: CFTimeInterval) {
        let storkeLayer = CAShapeLayer()
        storkeLayer.fillColor = fillColor.cgColor //this is the fill inside the uicell, not the borders of it
        storkeLayer.strokeColor = borderColor.cgColor
        storkeLayer.lineWidth = 6
        
        // Create a rounded rect path using button's bounds.
        storkeLayer.path = CGPath.init(roundedRect: image.bounds, cornerWidth: cornerRadious, cornerHeight: cornerRadious, transform: nil) // same path like the empty one ...
        // Add layer to the button
        image.layer.addSublayer(storkeLayer)
        
        // Create animation layer and add it to the stroke layer.
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(1.0)
        animation.duration = animationTime
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        storkeLayer.add(animation, forKey: "circleAnimation")
    }
}

extension String {
    subscript(i: Int) -> String {
        return  i < count ? String(self[index(startIndex, offsetBy: i)]) : ""
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
