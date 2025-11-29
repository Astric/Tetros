//
//  ColorConfig.swift
//  Tetros
//
//  Created by Kostas on 29/11/2025.
//

import UIKit

enum ColorConfig {
    static let blockColors: [Int: CGColor] = [
        0: UIColor.clear.cgColor,           // Empty
        1: UIColor.systemCyan.cgColor,      // I
        2: UIColor.systemBlue.cgColor,      // O
        3: UIColor.systemPurple.cgColor,    // T
        4: UIColor.systemOrange.cgColor,    // J
        5: UIColor.systemYellow.cgColor,    // L
        6: UIColor.systemGreen.cgColor,     // S
        7: UIColor.systemRed.cgColor,       // Z
    ]
}
