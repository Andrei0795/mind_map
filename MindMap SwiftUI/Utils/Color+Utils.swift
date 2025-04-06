//
//  Color+Utils.swift
//  MindMap SwiftUI
//
//  Created by Andrei Ionescu on 03.04.2025.
//

import SwiftUICore
import UIKit

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)

        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
    
    func toHex() -> String {
            let uiColor = UIColor(self)
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
            let r = Int(red * 255), g = Int(green * 255), b = Int(blue * 255)
            return String(format: "#%02X%02X%02X", r, g, b)
        }
}
