//  JigsawPieceShape.swift
//  Quizzy Kids

import SwiftUI

struct JigsawPieceShape: Shape {
    let edges: PieceEdges
    var tabSize: CGFloat = 0.22
    var tabDepth: CGFloat = 0.27
    var padding: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        let base = rect.insetBy(dx: padding, dy: padding)
        let ox = base.minX
        let oy = base.minY
        let w = base.width
        let h = base.height
        
        let t = min(w, h) * tabSize
        let d = min(w, h) * tabDepth
        
        func bump(_ edge: PuzzleEdge, forward: Bool) -> CGFloat {
            switch edge {
            case .flat: return 0
            case .out: return forward ? d : -d
            case .in: return forward ? -d : d
            }
        }
        
        var p = Path()
        p.move(to: CGPoint(x: ox, y: oy))
        
        if case .flat = edges.top {
            p.addLine(to: CGPoint(x: ox + w, y: oy))
        } else {
            let mid = ox + w * 0.5
            let b = bump(edges.top, forward: true)
            p.addLine(to: CGPoint(x: mid - t, y: oy))
            p.addCurve(
                to: CGPoint(x: mid + t, y: oy),
                control1: CGPoint(x: mid - t, y: oy + b),
                control2: CGPoint(x: mid + t, y: oy + b)
            )
            p.addLine(to: CGPoint(x: ox + w, y: oy))
        }
        
        if case .flat = edges.right {
            p.addLine(to: CGPoint(x: ox + w, y: oy + h))
        } else {
            let mid = oy + h * 0.5
            let b = bump(edges.right, forward: true)
            p.addLine(to: CGPoint(x: ox + w, y: mid - t))
            p.addCurve(
                to: CGPoint(x: ox + w, y: mid + t),
                control1: CGPoint(x: ox + w + b, y: mid - t),
                control2: CGPoint(x: ox + w + b, y: mid + t)
            )
            p.addLine(to: CGPoint(x: ox + w, y: oy + h))
        }
        
        if case .flat = edges.bottom {
            p.addLine(to: CGPoint(x: ox, y: oy + h))
        } else {
            let mid = ox + w * 0.5
            let b = bump(edges.bottom, forward: false)
            p.addLine(to: CGPoint(x: mid + t, y: oy + h))
            p.addCurve(
                to: CGPoint(x: mid - t, y: oy + h),
                control1: CGPoint(x: mid + t, y: oy + h + b),
                control2: CGPoint(x: mid - t, y: oy + h + b)
            )
            p.addLine(to: CGPoint(x: ox, y: oy + h))
        }
        
        if case .flat = edges.left {
            p.closeSubpath()
        } else {
            let mid = oy + h * 0.5
            let b = bump(edges.left, forward: false)
            p.addLine(to: CGPoint(x: ox, y: mid + t))
            p.addCurve(
                to: CGPoint(x: ox, y: mid - t),
                control1: CGPoint(x: ox + b, y: mid + t),
                control2: CGPoint(x: ox + b, y: mid - t)
            )
            p.closeSubpath()
        }
        return p
    }
}
    

