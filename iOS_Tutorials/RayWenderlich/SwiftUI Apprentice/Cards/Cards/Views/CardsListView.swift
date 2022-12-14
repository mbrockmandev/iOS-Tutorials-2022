  //
  //  CardsListView.swift
  //  Cards
  //
  //  Created by Michael Brockman on 10/6/22.
  //

import SwiftUI

struct CardsListView: View {
  @EnvironmentObject var viewState: ViewState
  @EnvironmentObject var store: CardStore
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack {
        ForEach(store.cards) { card in
          CardThumbnailView(card: card)
            .onTapGesture {
              viewState.selectedCard = card
              viewState.showAllCards.toggle()
            }
        }
      }
    }
  }
}
struct CardsListView_Previews: PreviewProvider {
  static var previews: some View {
    CardsListView()
      .environmentObject(ViewState())
      .environmentObject(CardStore(defaultData: true))
  }
}

