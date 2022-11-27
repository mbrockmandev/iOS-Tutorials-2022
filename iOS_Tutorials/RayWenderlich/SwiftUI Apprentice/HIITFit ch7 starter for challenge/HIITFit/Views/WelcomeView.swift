//
//  WelcomeView.swift
//  HIITFit
//
//  Created by Michael Brockman on 10/3/22.
//

import SwiftUI

struct WelcomeView: View {
  @State private var showHistory = false
  
  let history: HistoryStore
  @Binding var selectedTab: Int
  
    var body: some View {
      ZStack {
        VStack {
          HeaderView(selectedTab: $selectedTab, titleText: NSLocalizedString("Welcome", comment: "greeting"))
          Spacer()
          Button(NSLocalizedString("History", comment: "view user activity")) {
            showHistory.toggle()
          }
          .sheet(isPresented: $showHistory, content: {
            HistoryView(showHistory: $showHistory, history: history)
          })
            .padding(.bottom)
        }
        VStack {
          HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
              Text(NSLocalizedString("Get fit", comment: "invitation to exercise"))
                .font(.largeTitle)
              Text("with high intensity interval training")
                .font(.headline)
            }
            Image("step-up")
              .resizedToFill(width: 240, height: 240)
              .clipShape(Circle())
          }
          Button {
            selectedTab = 0
          } label: {
            Text(NSLocalizedString("Get Started", comment: "invitation"))
            Image(systemName: "arrow.right.circle")
          }
          .font(.title2)
          .padding()
          .background(RoundedRectangle(cornerRadius: 20)
            .stroke(Color.gray, lineWidth: 2))
        }
      }
    }
}

//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//      WelcomeView(selectedTab: .constant(9))
//    }
//}

