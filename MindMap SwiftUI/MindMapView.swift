//
//  MindMapView.swift
//  MindMap SwiftUI
//
//  Created by Andrei Ionescu on 03.04.2025.
//

import SwiftUI
import SwiftData

struct MindMapView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \MindNode.title) var allNodes: [MindNode]
    
    @FocusState private var isTextFieldFocused: Bool
    @State private var viewModel: MindMapViewModel?
    @State private var connections: [NodeConnection] = []
    
    @State private var exportSize: CGSize = CGSize(width: 1000, height: 1000)
    
    @FocusState private var dummyFocus: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Title
                Text("Mind Map")
                    .font(.largeTitle.bold())
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.systemBackground))
                
                Divider()
                
                // Interactive Area
                ZoomableView {
                    ZStack {
                        // 1. Lines
                        Canvas { context, size in
                            for conn in connections {
                                let midX = (conn.from.x + conn.to.x) / 2
                                let control1 = CGPoint(x: midX, y: conn.from.y)
                                let control2 = CGPoint(x: midX, y: conn.to.y)
                                
                                var path = Path()
                                path.move(to: conn.from)
                                path.addCurve(to: conn.to, control1: control1, control2: control2)
                                
                                context.stroke(path, with: .color(conn.color), lineWidth: 2)
                            }
                        }
                        .drawingGroup()
                        .zIndex(0)
                        
                        // Nodes
                        if let viewModel {
                            MindNodeView(
                                viewModel: viewModel,
                                node: viewModel.rootNode,
                                parentConnectionPoint: nil,
                                inheritColor: nil,
                                isFocused: $isTextFieldFocused
                            )
                            .padding()
                            .zIndex(1)
                        } else {
                            ProgressView("Loading...")
                                .onAppear {
                                    loadOrCreateRootNode()
                                }
                        }
                        
                        // Tapping outside to dismiss focus
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isTextFieldFocused = false
                            }
                            .allowsHitTesting(true) // optional
                    }
                    .coordinateSpace(name: "mindmap")
                    .onPreferenceChange(NodeConnectionKey.self) {
                        self.connections = $0
                    }
                }
                .simultaneousGesture(
                    TapGesture().onEnded {
                        isTextFieldFocused = false
                    }
                )
                .clipped()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Delete All") {
                        deleteAllNodesExceptRoot()
                    }
                    
                    Button("Save PDF") {
                        saveMindMapAsPDF()
                    }
                }
            }
        }
    }
    
    private func loadOrCreateRootNode() {
        if let existingRoot = allNodes.first(where: { $0.parent == nil }) {
            viewModel = MindMapViewModel(rootNode: existingRoot)
        } else {
            let root = MindNode(title: "Root Node", colorHex: "#3498db")
            modelContext.insert(root)
            try? modelContext.save()
            viewModel = MindMapViewModel(rootNode: root)
        }
    }
    
    private func deleteAllNodesExceptRoot() {
        if let root = allNodes.first(where: { $0.parent == nil }) {
            for node in allNodes where node.id != root.id {
                modelContext.delete(node)
            }
            root.children = []
            try? modelContext.save()
            
            viewModel = nil
            
            DispatchQueue.main.async {
                if let refreshedRoot = allNodes.first(where: { $0.parent == nil }) {
                    viewModel = MindMapViewModel(rootNode: refreshedRoot)
                }
            }
        }
    }
    
    private func saveMindMapAsPDF() {
        let exportSize = CGSize(width: 2000, height: 2000)
        
        let rootView = ZStack {
            Color.white
            
            if let viewModel {
                MindNodeView(
                    viewModel: viewModel,
                    node: viewModel.rootNode,
                    parentConnectionPoint: nil,
                    inheritColor: nil,
                    isFocused: $dummyFocus
                )
                .padding()
            }
        }
            .frame(width: exportSize.width, height: exportSize.height)
        
        // Render using UIKit's PDF renderer
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: exportSize))
        let data = renderer.pdfData { ctx in
            ctx.beginPage()
            
            let controller = UIHostingController(rootView: rootView)
            controller.view.frame = CGRect(origin: .zero, size: exportSize)
            
            let window = UIWindow(frame: controller.view.frame)
            window.rootViewController = controller
            window.makeKeyAndVisible()
            
            controller.view.layoutIfNeeded()
            
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
        
        // Save and share
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("MindMap.pdf")
        do {
            try data.write(to: url)
            print("PDF saved at: \(url)")
            
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let root = scene.windows.first?.rootViewController {
                root.present(activityVC, animated: true)
            }
        } catch {
            print("Failed to write PDF:", error)
        }
    }
}
