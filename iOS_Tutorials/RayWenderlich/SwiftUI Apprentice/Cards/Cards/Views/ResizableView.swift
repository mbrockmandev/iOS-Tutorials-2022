  //
  //  ResizableView.swift
  //  Cards
  //
  //  Created by Michael Brockman on 10/7/22.
  //

import SwiftUI

struct ResizableView: ViewModifier {
  
  @Binding var transform: Transform
  @State private var previousOffset: CGSize = .zero
  @State private var previousRotation: Angle = .zero
  @State private var scale: CGFloat = 1.0
  
  func body (content: Content) -> some View {
    let scaleGesture = MagnificationGesture()
      .onChanged { scale in
        self.scale = scale
      }
      .onEnded { scale in
        transform.size.width *= scale
        transform.size.height *= scale
        self.scale = 1.0
      }
    
    let rotationGesture = RotationGesture()
      .onChanged { rotation in
        transform.rotation += rotation - previousRotation
        previousRotation = rotation
      }
      .onEnded { _ in
        previousRotation = .zero
      }
    
    let dragGesture = DragGesture()
      .onChanged { value in
        transform.offset = value.translation + previousOffset
      }
      .onEnded { _ in
        previousOffset = transform.offset
      }
    //order of operations matters -- can screw up rotation or drag gestures
    content
      .frame(
        width: transform.size.width,
        height: transform.size.height)
      .offset(transform.offset)
      .rotationEffect(transform.rotation)
      .scaleEffect(scale)
      .gesture(dragGesture)
      .gesture(SimultaneousGesture(rotationGesture, scaleGesture))
      .onAppear {
        previousOffset = transform.offset
      }
  }
}

struct ResizableView_Previews: PreviewProvider {
  static var previews: some View {
    RoundedRectangle(cornerRadius: 30.0)
      .foregroundColor(.red)
      .resizableView(transform: .constant(Transform()))
  }
}
