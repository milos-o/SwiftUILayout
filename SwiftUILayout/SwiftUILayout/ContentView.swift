//
//  ContentView.swift
//  SwiftUILayout
//
//  Created by Milos on 16. 8. 2025..
//

import SwiftUI
import Foundation

var sample: some View_ {
    Ellipse_()
        .frame(width: 200, height: 100)
        .border(NSColor.blue, width: 2)
        .frame(width: 300, height: 300, alignment: .topLeading)
        .border(NSColor.yellow, width: 2)
}

func render<V: View_>(view: V, size: CGSize) -> Data {
    return CGContext.pdf(size: size) { context in
        view
            .frame(width: size.width, height: size.height)
            ._render(context: context, size: size)
    }
}

struct ContentView: View {
    @State var opacity: Double = 0.5
    let size = CGSize(width: 600, height: 400)

    var body: some View {
        VStack {
            ZStack {
                Image(nsImage: NSImage(data: render(view: sample, size: size))!)
                    .opacity(1-opacity)
                sample.swiftUI.frame(width: size.width, height: size.height)
                    .opacity(opacity)
            }
            Slider(value: $opacity, in: 0...1)
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
