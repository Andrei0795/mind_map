//
//  UIColor+Utils.swift
//  MindMap SwiftUI
//
//  Created by Andrei Ionescu on 03.04.2025.
//
import UIKit

extension UIColor {
    static func randomHex() -> String {
        let r = Int.random(in: 0...255)
        let g = Int.random(in: 0...255)
        let b = Int.random(in: 0...255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
