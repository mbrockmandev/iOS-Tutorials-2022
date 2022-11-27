  //
  //  ContainerView.swift
  //  HIITFit
  //
  //  Created by Michael Brockman on 10/5/22.
  //

import SwiftUI

struct ContainerView<Content: View>: View {
  var content: Content
  
  var body: some View {
    
    ZStack {
      RoundedRectangle(cornerRadius: 25.0)
        .foregroundColor(Color("background"))
      VStack {
        Spacer()
        Rectangle()
          .frame(height: 25)
          .foregroundColor(Color("background"))
      }
      content
    }
  }
  
  
    //MARK: - init
  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  
}

struct ContainerView_Previews: PreviewProvider {
  static var previews: some View {
    ContainerView {
      VStack {
        RaisedButton(buttonText: "Hello world!") {
            //
        }
        .padding(50)
        Button("Tap Me!") {}
          .buttonStyle(EmbossedButtonStyle(buttonShape: .round))
      }
    }
    .padding(50)
    .previewLayout(.sizeThatFits)
  }
}
