//
//  Frames.swift
//  SwiftUILayout
//
//  Created by Milos on 19. 8. 2025..
//

import SwiftUI

struct FixedFrame<Content: View_>: View_, BuiltinView {
    var width: CGFloat?
    var height: CGFloat?
    var alignment: Alignment_
    var content: Content
    
    func size(proposed: ProposedSize) -> CGSize {
        let childSize = content._size(proposed: ProposedSize(width: width ?? proposed.width, height: height ?? proposed.height))
        return CGSize(width: width ?? childSize.width, height: height ?? childSize.height)
    }
    
    func render(context: RenderingContext, size: ProposedSize) {
        context.saveGState()
        let childSize = content._size(proposed: size)
        
        let selfPoint = alignment.point(for: size)
        let childPoint = alignment.point(for: childSize)
        context.translateBy(x: selfPoint.x - childPoint.x, y: selfPoint.y - childPoint.y)
        content._render(context: context, size: childSize)
        context.restoreGState()
    }
    
    var swiftUI: some View {
        content.swiftUI.frame(width: width, height: height, alignment: alignment.swiftUI)
    }
}

extension View_ {
    func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment_ = .center) -> some View_ {
        FixedFrame(width: width, height: height, alignment: alignment, content: self)
    }
}
