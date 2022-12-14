/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack(alignment: .customCenter) {
      HStack {
        ScaledImage("Trig")
        ScaledImage("Patterns")
        Text("Learn SwiftUI layout!")
          .alignmentGuide(.customCenter) { $0[.leading] }
      }

      HStack {
        Text("Help others learn it too!")
        ScaledImage("Hearts")
          .background(Color.red)
          .alignmentGuide(.customCenter) { $0[.trailing] }
      }

      HStack {
        ScaledImage("Rocket")
        Text("Then let's all make some awesome apps!")
          .multilineTextAlignment(.center)
        ScaledImage("Party")
      }
    }
      .frame(width: 250, height: 250)
  }
}

extension HorizontalAlignment {
  enum CustomCenter: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[HorizontalAlignment.center]
    }
  }

  static let customCenter = Self(CustomCenter.self)
}

struct ScaledImage: View {
  let name: String

  init(_ name: String) {
    self.name = name
  }

  var body: some View {
    Image(name)
      .resizable()
      .scaledToFit()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View { ContentView() }
}
