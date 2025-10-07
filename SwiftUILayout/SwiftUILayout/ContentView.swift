//
//  ContentView.swift
//  SwiftUILayout
//
//  Created by Milos on 16. 8. 2025..
//

import SwiftUI
#if os(macOS)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

func render<V: View_>(view: V, size: CGSize) -> Data {
    return CGContext.image(size: size) { context in
        view
            .frame(width: size.width, height: size.height)
            ._render(context: context, size: size)
    }
}

enum MyLeading: AlignmentID, SwiftUI.AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        0
    }
    
    static func defaultValue(in context: CGSize) -> CGFloat {
        0
    }
}

extension HorizontalAlignment_ {
    static let myLeading  = HorizontalAlignment_(alignmentID: MyLeading.self, swiftUI: HorizontalAlignment( MyLeading.self))
}

struct ContentView: View {
    @State var opacity: Double = 0.5
    @State var width: CGFloat = 300
    @State var minWidth: (CGFloat, enabled: Bool) = (100, true)
    @State var maxWidth: (CGFloat, enabled: Bool) = (400, true)

    let size = CGSize(width: 600, height: 400)

    var sample: some View_ {
        VGrid(
            columns: [
                .fixed(100),
                .flexible(minimum: 10, maximum: 50),
                .flexible(minimum: 100, maximum: 200)
            ],
            content: [
                AnyView_(Rectangle_()
                    .foregroundColor(Color_.red)
                    .measured),
                AnyView_(Rectangle_()
                    .foregroundColor(Color_.green)
                    .frame(minHeight: 50)
                    .measured),
                AnyView_(Rectangle_()
                    .foregroundColor(Color_.yellow)
                    .measured)
            ]
        )
        .border(Color_.blue, width: 1)
        .frame(width: width, height: 200)
        .border(Color_.red, width: 1)
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
            .border(Color_.blue, width: 2)
            .frame(width: width.rounded(), height: 300)
            .border(Color_.yellow, width: 2)
    }
    
    var body: some View {
          VStack {
              ZStack {
                  Image(native: Image_(data: render(view: sample, size: size))!)
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
