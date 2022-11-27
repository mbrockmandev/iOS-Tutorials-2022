  //
  //  CardDetailView.swift
  //  Cards
  //
  //  Created by Michael Brockman on 10/6/22.
  //

import SwiftUI

struct CardDetailView: View {
  @Binding var card: Card
  @State private var currentModal: CardModal?
  @EnvironmentObject var viewState: ViewState
  
  
  var body: some View {
    content
      .modifier(CardToolbar(currentModal: $currentModal))
  }
  
  var content: some View {
    ZStack {
      card.backgroundColor
        .edgesIgnoringSafeArea(.all)
      ForEach(card.elements, id: \.id) { element in
        CardElementView(element: element)
          .contextMenu {
            Button {
              card.remove(element)
            } label: {
              Text("Delete")
              Image(systemName: "trash")
            }
          }
          .resizableView(transform: bindingTransform(for: element))
          .frame(
            width: element.transform.size.width,
            height: element.transform.size.height)
      }
    }
  }
  
  func bindingTransform(for element: CardElement) -> Binding<Transform> {
    guard let index = element.index(in: card.elements) else { fatalError("Element does not exist") }
    return $card.elements[index].transform
  }
}

struct CardDetailView_Previews: PreviewProvider {
  static var previews: some View {
    CardDetailView(card: .constant(initialCards[0]))
      .environmentObject(ViewState())
  }
}
