//
//  UIColor.swift
//  Tetros
//
//  Created by Kostas on 29/11/2025.
//

import UIKit

extension UIColor {
    func lighter(by percentage: CGFloat = 0.3) -> UIColor {
        return self.adjust(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 0.3) -> UIColor {
        return self.adjust(by: -abs(percentage))
    }

    private func adjust(by percentage: CGFloat) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(
                red: min(max(red + percentage, 0.0), 1.0),
                green: min(max(green + percentage, 0.0), 1.0),
                blue: min(max(blue + percentage, 0.0), 1.0),
                alpha: alpha
            )
        }
        return self
    }
}
