//
//  MindMapViewModel.swift
//  MindMap SwiftUI
//
//  Created by Andrei Ionescu on 03.04.2025.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class MindMapViewModel {
    var rootNode: MindNode

    init(rootNode: MindNode) {
        self.rootNode = rootNode
    }

    func addChild(to parent: MindNode, title: String, colorHex: String = "#f39c12") {
        let newNode = MindNode(title: title, colorHex: colorHex, parent: parent)
        parent.children.append(newNode)
    }

    func delete(_ node: MindNode) {
        if let parent = node.parent {
            parent.children.removeAll { $0.id == node.id }
        }
    }
}
