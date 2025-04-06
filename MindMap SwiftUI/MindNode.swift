//
//  MindNode.swift
//  MindMap SwiftUI
//
//  Created by Andrei Ionescu on 03.04.2025.
//

import Foundation
import SwiftData

@Model
class MindNode {
    var id: UUID
    var title: String
    var colorHex: String
    var children: [MindNode]
    var parent: MindNode?

    init(title: String, colorHex: String = "#34a1eb", parent: MindNode? = nil) {
        self.id = UUID()
        self.title = title
        self.colorHex = colorHex
        self.children = []
        self.parent = parent
    }
}
