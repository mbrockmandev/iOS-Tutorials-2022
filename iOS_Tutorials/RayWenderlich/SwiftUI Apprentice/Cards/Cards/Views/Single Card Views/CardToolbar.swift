  //
  //  ResizableView.swift
  //  Cards
  //
  //  Created by Michael Brockman on 10/7/22.
  //

import SwiftUI

struct CardToolbar: ViewModifier {
  @Binding var currentModal: CardModal?
  
  @EnvironmentObject var viewState: ViewState
  
  func body (content: Content) -> some View {
    content
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            viewState.showAllCards.toggle()
          } label: {
            Text("Done")
          }
        }
        ToolbarItem(placement: .bottomBar) {
          CardBottomToolbar(cardModal: $currentModal)
        }
      }
  }
}


  //  let scaleGesture = MagnificationGesture()
  //    .onChanged { scale in
  //      self.scale = scale
  //    }
  //    .onEnded { scale in
  //      transform.size.width *= scale
  //      transform.size.height *= scale
  //      self.scale = 1.0
  //    }
  //
  //  let rotationGesture = RotationGesture()
  //    .onChanged { rotation in
  //      transform.rotation += rotation - previousRotation
  //      previousRotation = rotation
  //    }
  //    .onEnded { _ in
  //      previousRotation = .zero
  //    }
  //
  //  let dragGesture = DragGesture()
  //    .onChanged { value in
  //      transform.offset = value.translation + previousOffset
  //    }
  //    .onEnded { _ in
  //      previousOffset = transform.offset
  //    }
  //    //order of operations matters -- can screw up rotation or drag gestures
  //  content
  //    .frame(
  //      width: transform.size.width,
  //      height: transform.size.height)
  //    .offset(transform.offset)
  //    .rotationEffect(transform.rotation)
  //    .scaleEffect(scale)
  //    .gesture(dragGesture)
  //    .gesture(SimultaneousGesture(rotationGesture, scaleGesture))
  //
  //  }
