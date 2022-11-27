  //
  //  RaisedButton.swift
  //  HIITFit
  //
  //  Created by Michael Brockman on 10/5/22.
  //

import SwiftUI

  //MARK: - Main View
struct RaisedButton: View {
  let buttonText: String
  let action: () -> Void
  @State private var buttonPressed = false
  
  var body: some View {
    Button {
      action()
    } label: {
      Text(buttonText)
        .raisedButtonTextStyle()
    }
    .onTapGesture {
      buttonPressed.toggle()
    }
    .buttonStyle(RaisedButtonStyle())
  }
}
  //MARK: - RaisedButton Preview
struct RaisedButton_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      RaisedButton(buttonText: "Get Started") {
        print("Hello world!")
      }
        .buttonStyle(RaisedButtonStyle())
        .padding(20)
    }
    .background(Color("background"))
    .previewLayout(.sizeThatFits)
  }
}

  //MARK: - Text Extension
extension Text {
  func raisedButtonTextStyle() -> some View {
    self
      .font(.body)
      .bold()
  }
}

  //MARK: - RaisedButtonStyle
struct RaisedButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(maxWidth: .infinity)
      .padding([.top, .bottom], 12)
      .background(
        Capsule()
          .foregroundColor(Color("background"))
          .shadow(color: Color("drop-shadow"), radius: 4, x: 6, y: 6)
          .shadow(color: Color("drop-highlight"), radius: 4, x: -6, y: -6)
      )
  }
}

