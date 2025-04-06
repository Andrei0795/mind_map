//
//  View+Utils.swift
//  MindMap SwiftUI
//
//  Created by Andrei Ionescu on 06.04.2025.
//

import UIKit
import SwiftUI

func generatePDF<V: View>(from view: V, size: CGSize, completion: @escaping (URL?) -> Void) {
    let hostingController = UIHostingController(rootView: view)
    hostingController.view.frame = CGRect(origin: .zero, size: size)

    let window = UIWindow(frame: hostingController.view.frame)
    window.rootViewController = hostingController
    window.makeKeyAndVisible()
    hostingController.view.layoutIfNeeded()

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { 
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: size))
        let data = renderer.pdfData { ctx in
            ctx.beginPage()
            hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("MindMap.pdf")
        do {
            try data.write(to: url)
            completion(url)
        } catch {
            print("❌ Failed to write PDF:", error)
            completion(nil)
        }
    }
}
