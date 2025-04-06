//
//  ZoomableView.swift
//  MindMap SwiftUI
//
//  Created by Andrei Ionescu on 06.04.2025.
//

import SwiftUI

struct ZoomableView<Content: View>: View {
    @GestureState private var gestureScale: CGFloat = 1.0
    @State private var scale: CGFloat = 1.0

    @GestureState private var gestureOffset: CGSize = .zero
    @State private var offset: CGSize = .zero

    let minScale: CGFloat = 0.5
    let maxScale: CGFloat = 3.0

    var content: () -> Content

    var body: some View {
        GeometryReader { geo in
            content()
                .transformEffect(
                    CGAffineTransform(scaleX: scale * gestureScale, y: scale * gestureScale)
                        .concatenating(
                            CGAffineTransform(translationX: offset.width + gestureOffset.width,
                                              y: offset.height + gestureOffset.height)
                        )
                )
                .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .updating($gestureScale) { value, state, _ in
                                state = value
                            }
                            .onEnded { value in
                                scale = min(max(minScale, scale * value), maxScale)
                            },
                        DragGesture()
                            .updating($gestureOffset) { value, state, _ in
                                state = value.translation
                            }
                            .onEnded { value in
                                offset.width += value.translation.width
                                offset.height += value.translation.height
                            }
                    )
                )
        }
    }
}
