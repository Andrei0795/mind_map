//
//  NodeCardView.swift
//  MindMap SwiftUI
//
//  Created by Andrei Ionescu on 05.04.2025.
//

import SwiftUI
import SwiftData

struct NodeCardView: View {
    let node: MindNode
    @Bindable var viewModel: MindMapViewModel
    let inheritColor: Color?
    @Environment(\.modelContext) var modelContext
    @State private var dynamicHeight: CGFloat = 40
    @FocusState.Binding var isFocused: Bool
    
    private let maxTextWidth: CGFloat = 240
    private let minTextWidth: CGFloat = 160

    var body: some View {
        let displayColor = inheritColor ?? Color(hex: node.colorHex)

        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(displayColor)
                    .frame(width: 28, height: 28)
                    .overlay(Circle().stroke(Color.black.opacity(0.1), lineWidth: 0.5))

                if inheritColor == nil {
                    // Only allow color picking if color is editable
                    ColorPicker(
                        "",
                        selection: Binding(
                            get: { Color(hex: node.colorHex) },
                            set: { newColor in
                                node.colorHex = newColor.toHex()
                                try? modelContext.save()
                            }
                        )
                    )
                    .labelsHidden()
                    .frame(width: 44, height: 44)
                    .opacity(0.01)
                    .contentShape(Circle())
                }
            }
            
            ResizableTextView(
                text: Binding(
                    get: { node.title },
                    set: {
                        node.title = $0
                        try? modelContext.save()
                    }
                ),
                dynamicHeight: $dynamicHeight
            )
            .focused($isFocused)
            .frame(width: maxTextWidth, height: dynamicHeight)
            .padding(8)
            .background(Color.white)
            .cornerRadius(6)

            Button(action: {
                DispatchQueue.main.async {
                    let newTitle = "Node \(node.children.count + 1)"
                    let newColor = inheritColor == nil ? UIColor.randomHex() : node.colorHex

                    viewModel.addChild(to: node, title: newTitle, colorHex: newColor)
                    modelContext.insert(node.children.last!)
                    try? modelContext.save()
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
            }

            Menu {
                Button(role: .destructive) {
                    viewModel.delete(node)
                    try? modelContext.save()
                } label: {
                    Label("Delete Node", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .padding(.horizontal, 4)
            }
        }
        .contentShape(Rectangle()) // Makes entire area tappable
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}
