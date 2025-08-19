//
//  Alignment.swift
//  SwiftUILayout
//
//  Created by Milos on 19. 8. 2025..
//

import SwiftUI

struct Alignment_ {
    var horizontal: HorizontalAlignment_
    var vertical: VerticalAlignment_
    var swiftUI: Alignment {
        Alignment(horizontal: horizontal.swiftUI, vertical: vertical.swiftUI)
    }
    
    static let center = Self(horizontal: .center, vertical: .center)
    static let topLeading = Self(horizontal: .leading, vertical: .top)
}

struct HorizontalAlignment_ {
    var alignmentID: AlignmentID.Type
    var swiftUI: HorizontalAlignment
    
    static let leading = Self(alignmentID: HLeading.self, swiftUI: .leading)
    static let center = Self(alignmentID: HCenter.self, swiftUI: .center)
    static let trailing = Self(alignmentID: HTrailing.self, swiftUI: .trailing)
}

struct VerticalAlignment_ {
    var alignmentID: AlignmentID.Type
    var swiftUI: VerticalAlignment
    
    static let top = Self(alignmentID: VTop.self, swiftUI: .top)
    static let center = Self(alignmentID: VCenter.self, swiftUI: .center)
}

protocol AlignmentID {
    static func defaultValue(in context: CGSize) -> CGFloat
}

enum VTop: AlignmentID {
    static func defaultValue(in context: CGSize) -> CGFloat { context.height }
}

enum VCenter: AlignmentID {
    static func defaultValue(in context: CGSize) -> CGFloat { context.height/2 }
}

enum HLeading: AlignmentID {
    static func defaultValue(in context: CGSize) -> CGFloat { 0 }
}

enum HCenter: AlignmentID {
    static func defaultValue(in context: CGSize) -> CGFloat { context.width/2 }
}

enum HTrailing: AlignmentID {
    static func defaultValue(in context: CGSize) -> CGFloat { context.width }
}

extension Alignment_ {
    func point(for size: CGSize) -> CGPoint {
        let x = horizontal.alignmentID.defaultValue(in: size)
        let y = vertical.alignmentID.defaultValue(in: size)
        return CGPoint(x: x, y: y)
    }
}
