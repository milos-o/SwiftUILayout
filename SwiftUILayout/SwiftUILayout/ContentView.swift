//
//  ContentView.swift
//  SwiftUILayout
//
//  Created by Milos on 16. 8. 2025..
//

import SwiftUI
import Foundation

protocol View_ {
    associatedtype Body: View_
    var body: Body { get }
}

typealias RenderingContext = CGContext
typealias ProposedSize = CGSize

protocol BuiltinView {
    func render(context: RenderingContext, size: CGSize)
    func size(proposed: ProposedSize) -> CGSize
    typealias Body = Never
}

extension View_ where Body == Never {
    var body: Never {
        fatalError("This should never be called.")
    }
}

extension Never: View_ {
    typealias Body = Never
}

extension View_ {
    func _render(context: RenderingContext, size: CGSize) {
        if let builtin = self as? BuiltinView {
            builtin.render(context: context, size: size)
        } else {
            body._render(context: context, size: size)
        }
    }
    
    func _size(proposed: ProposedSize) -> CGSize {
        if let builtin = self as? BuiltinView {
            return builtin.size(proposed: proposed)
        } else {
            return body._size(proposed: proposed)
        }
    }
}

protocol Shape_: View_ {
    func path(in rect: CGRect) -> CGPath
}

extension Shape_ {
    var body: some View_ {
        ShapeView(shape: self)
    }
}

extension NSColor: View_ {
    var body: some View_ {
        ShapeView(shape: Rectangle_(), color: self)
    }
}

struct ShapeView<S: Shape_>: BuiltinView, View_ {
    var shape: S
    var color: NSColor = .red
    
    func size(proposed: ProposedSize) -> CGSize {
        return proposed
    }
    
    func render(context: RenderingContext, size: ProposedSize) {
        context.saveGState()
        context.setFillColor(color.cgColor)
        context.addPath(shape.path(in: CGRect(origin: .zero, size: size)))
        context.fillPath()
        context.restoreGState()
    }
}

struct Rectangle_: Shape_ {
    func path(in rect: CGRect) -> CGPath {
        CGPath(rect: rect, transform: nil)
    }
}

struct Ellipse_: Shape_ {
    func path(in rect: CGRect) -> CGPath {
        CGPath(ellipseIn: rect, transform: nil)
    }
}

struct FixedFrame<Content: View_>: View_, BuiltinView {
    var width: CGFloat?
    var height: CGFloat?
    var content: Content
    
    func size(proposed: ProposedSize) -> CGSize {
        let childSize = content._size(proposed: ProposedSize(width: width ?? proposed.width, height: height ?? proposed.height))
        return CGSize(width: width ?? childSize.width, height: height ?? childSize.height)
    }
    
    func render(context: RenderingContext, size: ProposedSize) {
        context.saveGState()
        let childSize = content._size(proposed: size)
        let x = (size.width - childSize.width) / 2
        let y = (size.height - childSize.height) / 2
        context.translateBy(x: x, y: y)
        content._render(context: context, size: childSize)
        context.restoreGState()
    }
}

extension View_ {
    func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> some View_ {
        FixedFrame(width: width, height: height, content: self)
    }
}

var sample: some View_ {
    NSColor.blue.frame(width: 200, height: 100)
}

func render<V: View_>(view: V) -> Data {
    let size = CGSize(width: 600, height: 400)
    return CGContext.pdf(size: size) { context in
        view
            .frame(width: size.width, height: size.height)
            ._render(context: context, size: size)
    }
}

struct ContentView: View {
    var body: some View {
        Image(nsImage: NSImage(data: render(view: sample))!)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
