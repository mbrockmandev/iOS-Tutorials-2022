  //
  //  DetailView.swift
  //  h4x0rn3wz
  //
  //  Created by Michael Brockman on 8/30/22.
  //

import SwiftUI
import WebKit

struct DetailView: View {
  let url: String?
  
  var body: some View {
    WebView(urlString: url)
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(url: "https://www.google.com")
  }
}


