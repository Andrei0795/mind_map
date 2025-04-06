//
//  ResizableTextView.swift
//  MindMap SwiftUI
//
//  Created by Andrei Ionescu on 06.04.2025.
//

import SwiftUI

struct ResizableTextView: UIViewRepresentable {
    @Binding var text: String
    var minHeight: CGFloat = 40
    var maxHeight: CGFloat = 200

    @Binding var dynamicHeight: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.delegate = context.coordinator
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        ResizableTextView.recalculateHeight(view: uiView, result: $dynamicHeight)
    }

    static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let size = view.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude))
        DispatchQueue.main.async {
            result.wrappedValue = max(size.height, 40)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: ResizableTextView

        init(parent: ResizableTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
            ResizableTextView.recalculateHeight(view: textView, result: self.parent.$dynamicHeight)
        }
    }
}
