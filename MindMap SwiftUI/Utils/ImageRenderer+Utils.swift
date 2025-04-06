//
//  ImageRenderer+Utils.swift
//  MindMap SwiftUI
//
//  Created by Andrei Ionescu on 06.04.2025.
//

import SwiftUI
import UIKit

@MainActor
extension View {
    func exportAsPDF(to fileName: String, size: CGSize, completion: @escaping (URL?) -> Void) {
        let renderer = ImageRenderer(content: self)
        renderer.proposedSize = .init(size)

        // Render image first to draw into PDF context
        if let uiImage = renderer.uiImage {
            DispatchQueue.global(qos: .userInitiated).async {
                let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: size))
                let data = pdfRenderer.pdfData { ctx in
                    ctx.beginPage()
                    uiImage.draw(in: CGRect(origin: .zero, size: size))
                }

                // Save to temporary directory
                let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

                do {
                    try data.write(to: url)
                    DispatchQueue.main.async {
                        completion(url)
                    }
                } catch {
                    print("Failed to write PDF: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        } else {
            print("⚠️ Failed to render UI image for PDF export.")
            completion(nil)
        }
    }
}
