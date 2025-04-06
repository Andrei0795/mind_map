//
//  MindNodeView.swift
//  MindMap SwiftUI
//
//  Created by Andrei Ionescu on 03.04.2025.
//

import SwiftUI
import SwiftData

struct MindNodeView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var viewModel: MindMapViewModel
    let node: MindNode
    let parentConnectionPoint: CGPoint?
    let inheritColor: Color?

    @FocusState.Binding var isFocused: Bool
    @State private var bottomLeft: CGPoint = .zero

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            NodeCardView(
                node: node,
                viewModel: viewModel,
                inheritColor: inheritColor,
                isFocused: $isFocused
            )
            .background(
                GeometryReader { geo in
                    let frame = geo.frame(in: .named("mindmap"))

                    DispatchQueue.main.async {
                        self.bottomLeft = CGPoint(x: frame.minX, y: frame.maxY - 5)
                    }

                    let to = CGPoint(x: frame.minX, y: frame.midY)

                    return Color.clear.preference(key: NodeConnectionKey.self, value: {
                        guard let from = parentConnectionPoint else { return [] }
                        return [
                            NodeConnection(
                                from: from,
                                to: to,
                                color: inheritColor ?? Color(hex: node.colorHex)
                            )
                        ]
                    }())
                }
            )

            ForEach(node.children, id: \.id) { child in
                let isFirstLevel = node.parent == nil

                MindNodeView(
                    viewModel: viewModel,
                    node: child,
                    parentConnectionPoint: bottomLeft,
                    inheritColor: isFirstLevel ? nil : Color(hex: node.colorHex),
                    isFocused: $isFocused
                )
                .padding(.leading, 20)
                .padding(.vertical, 8)
            }
        }
    }
}
