//
//  RoundViews.swift
//  Bullseye
//
//  Created by Michael Brockman on 8/9/22.
//

import SwiftUI

struct RoundedImageViewStroked: View {
  var systemName: String
  
  var body: some View {
    Image(systemName: systemName)
      .font(.title)
      .foregroundColor(Color("TextColor"))
      .frame(width: K.General.roundRectViewWidth, height: K.General.roundRectViewHeight)
      .overlay(
        Circle()
          .strokeBorder(Color("ButtonStrokeColor"), lineWidth: K.General.strokeWidth)
      )

    
  }
}

struct RoundedImageViewFilled: View {
  var systemName: String
  
  var body: some View {
    Image(systemName: systemName)
      
      .font(.title)
      .foregroundColor(Color("ButtonFilledTextColor"))
      .frame(width: K.General.roundRectViewWidth, height: K.General.roundRectViewHeight)
      .background(
        Circle()
          .fill(Color("ButtonFilledBackgroundColor")))
  }
}

struct RoundRectTextView: View {
  var text: String
  
  var body: some View {
    Text(text)
      
      .kerning(-0.2)
      .bold()
      .font(.title3)
      .frame(width: K.General.roundRectViewWidth, height: K.General.roundRectViewHeight)
      .foregroundColor(Color("TextColor"))
      .overlay(
        RoundedRectangle(cornerRadius: K.General.roundRectCornerRadius)
          .stroke(lineWidth: K.General.strokeWidth)
          .foregroundColor(Color("ButtonStrokeColor"))
      )
  }
}

struct RoundedTextView: View {
  let text: String
  
  var body: some View {
    Text(text)
      .font(.title)
      .foregroundColor(Color("TextColor"))
      .frame(width: K.General.roundedViewLength, height: K.General.roundedViewLength)
      .overlay(
        Circle()
          .strokeBorder(Color("LeaderboardRowColor"), lineWidth: K.General.strokeWidth)
      )
  }
}


struct PreviewView: View {
  var body: some View {
    VStack(spacing: 10) {
      RoundedImageViewStroked(systemName: "arrow.counterclockwise")
      RoundedImageViewFilled(systemName: "list.dash")
      RoundRectTextView(text: "Score")
      RoundedTextView(text: "1")
    }
  }
}

struct RoundedViews_Previews: PreviewProvider {
  static var previews: some View {
    PreviewView()
    PreviewView()
      .preferredColorScheme(.dark)
    
  }
}
