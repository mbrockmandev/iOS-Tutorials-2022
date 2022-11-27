  //
  //  SingleCardView.swift
  //  Cards
  //
  //  Created by Michael Brockman on 10/6/22.
  //

import SwiftUI

struct SingleCardView: View {
  @EnvironmentObject var viewState: ViewState
  @EnvironmentObject var store: CardStore
  
  var body: some View {
    
    if let selectedCard = viewState.selectedCard,
       let index = store.index(for: selectedCard){
      NavigationView {
        CardDetailView(card: $store.cards[index])
          .navigationBarTitleDisplayMode(.inline)
      }
      .navigationViewStyle(StackNavigationViewStyle())
    }
  }
}

struct SingleCardView_Previews: PreviewProvider {
  static var previews: some View {
    SingleCardView()
      .environmentObject(ViewState(card: initialCards[0]))
      .environmentObject(CardStore(defaultData: true))
  }
}

