//
//  NodeAnchorPreference.swift
//  MindMap SwiftUI
//
//  Created by Andrei Ionescu on 04.04.2025.
//

import Foundation
import SwiftUICore

struct NodeConnection: Equatable {
    let from: CGPoint  // parent's bottom-left
    let to: CGPoint    // child's center-left
    let color: Color
}

struct NodeConnectionKey: PreferenceKey {
    static var defaultValue: [NodeConnection] = []

    static func reduce(value: inout [NodeConnection], nextValue: () -> [NodeConnection]) {
        value.append(contentsOf: nextValue())
    }
}
