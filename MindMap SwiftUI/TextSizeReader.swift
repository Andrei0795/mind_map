//
//  TextSizeReader.swift
//  MindMap SwiftUI
//
//  Created by Andrei Ionescu on 06.04.2025.
//

import SwiftUI

struct TextSizeReader: View {
    let text: String
    @Binding var textWidth: CGFloat

    var body: some View {
        Text(text)
            .lineLimit(nil)
            .fixedSize(horizontal: true, vertical: false)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            textWidth = geo.size.width
                        }
                        .onChange(of: geo.size.width) { newValue in
                            textWidth = newValue
                        }
                }
            )
            .hidden() // Don't show it
    }
}
