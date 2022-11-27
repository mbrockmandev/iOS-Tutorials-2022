  //
  //  CardElementView.swift
  //  Cards
  //
  //  Created by Michael Brockman on 10/8/22.
  //

import SwiftUI

  //MARK: - Card Element View
struct CardElementView: View {
  let element: CardElement
  
  var body: some View {
    if let element = element as? ImageElement {
      ImageElementView(element: element)
    }
    if let element = element as? TextElement {
      TextElementView(element: element)
    }
    
  }
}

  //MARK: - Text Element View
struct TextElementView: View {
  let element: TextElement
  
  var body: some View {
    if !element.text.isEmpty {
      Text(element.text)
        .font(.custom(element.textFont, size: 200))
        .foregroundColor(element.textColor)
        .scalableText()
    }
  }
}

//MARK: - Image Element View
struct ImageElementView: View {
  let element: ImageElement
  
  var body: some View {
    element.image
      .resizable()
      .aspectRatio(contentMode: .fit)
  }
}



  //MARK: - preview
struct CardElementView_Previews: PreviewProvider {
  static var previews: some View {
    CardElementView(element: initialElements[0])
  }
}


