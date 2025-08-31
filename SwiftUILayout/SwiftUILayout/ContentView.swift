//
//  ContentView.swift
//  SwiftUILayout
//
//  Created by Milos on 16. 8. 2025..
//

import SwiftUI
import Foundation

func render<V: View_>(view: V, size: CGSize) -> Data {
    return CGContext.pdf(size: size) { context in
        view
            .frame(width: size.width, height: size.height)
            ._render(context: context, size: size)
    }
}

struct ContentView: View {
    @State var opacity: Double = 0.5
    @State var width: CGFloat = 300
    @State var minWidth: (CGFloat, enabled: Bool) = (100, true)
    @State var maxWidth: (CGFloat, enabled: Bool) = (400, true)

    let size = CGSize(width: 600, height: 400)

    var sample: some View_ {
        HStack_(children: [
            AnyView_(
                Rectangle_()
                    .frame(minWidth: 150, maxWidth: 250)
                    .foregroundColor(.blue)
                    .measured
            ),
            AnyView_(
                Rectangle_()
                    .frame(maxWidth: 100)
                    .foregroundColor(.red)
                    .measured
            )
        ], alignment: .top)
        .frame(width: width.rounded(), height: 100)
    }
    
    var textExample: some View_ {
        Text_("Hello World")
            .fixedSize()
            .foregroundColor(.red)
            .frame(width: 150)
            .frame(minWidth: minWidth.enabled ? minWidth.0.rounded() : nil, maxWidth: maxWidth.enabled ? maxWidth.0.rounded() : nil)
            .overlay(GeometryReader_ { size in
                Text_("\(Int(size.width))x\(Int(size.height))")
            })
            .border(NSColor.blue, width: 2)
            .frame(width: width.rounded(), height: 300)
            .border(NSColor.yellow, width: 2)
    }
    
    var body: some View {
          VStack {
              ZStack {
                  Image(nsImage: NSImage(data: render(view: sample, size: size))!)
                      .opacity(1-opacity)
                  sample.swiftUI.frame(width: size.width, height: size.height)
                      .opacity(opacity)
              }
              Slider(value: $opacity, in: 0...1)
                  .padding()
              HStack {
                  Text("Width \(width.rounded())")
                  Slider(value: $width, in: 0...600)
              }.padding()
          }
          .frame(maxWidth: .infinity)
          .frame(height: 1080/2)
      }
}
