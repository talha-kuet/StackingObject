//
//  UIColor+Extension.swift
//  StackingObject
//
//  Created by Musaddique Billah Talha on 9/9/24.
//
import UIKit

extension UIColor {
    class func randomColor() -> UIColor {
        let colors: [UIColor] = [.red, .blue, .orange, .green, .cyan, .purple]
        let randomIndex = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[randomIndex]
    }
}
