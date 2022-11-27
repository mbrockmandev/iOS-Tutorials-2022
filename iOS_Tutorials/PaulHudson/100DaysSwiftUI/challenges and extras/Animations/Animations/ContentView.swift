//
//  ContentView.swift
//  Animations
//
//  Created by Michael Brockman on 7/30/22.
//

import SwiftUI

struct ContentView: View {
    let letters = Array("Hello, SwiftUI")
    
    @State private var animationAmount = 0.0
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(
                        .default.delay(Double(num) / 20),
                        value: dragAmount)
            }
        }
        .gesture(
        DragGesture()
            .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



//            LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                        .frame(width: 300, height: 200)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .offset(dragAmount)
//                        .gesture(
//                        DragGesture()
//                            .onChanged{ dragAmount = $0.translation }
//                            .onEnded { _ in
//                                withAnimation {
//                                    dragAmount = .zero}
//                            }
//                        )
