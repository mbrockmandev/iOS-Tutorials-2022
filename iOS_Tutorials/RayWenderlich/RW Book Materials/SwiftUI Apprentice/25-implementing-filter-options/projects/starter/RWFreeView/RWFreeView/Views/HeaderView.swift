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
  /// This project and source code may use libraries or frameworks that are
  /// released under various Open-Source licenses. Use of those libraries and
  /// frameworks are governed by their own individual licenses.
  ///
  /// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  /// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  /// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  /// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  /// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  /// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  /// THE SOFTWARE.

import SwiftUI

struct HeaderView: View {
  let count: Int
  @State private var queryTerm = ""
  @State private var sortOn = "none"
  @EnvironmentObject var store: EpisodeStore
  
  let threeColumns = [
    GridItem(.flexible(minimum: 55)),
    GridItem(.flexible(minimum: 55)),
    GridItem(.flexible(minimum: 55))
  ]
  
  var body: some View {
    VStack {
      SearchField(queryTerm: $queryTerm)
      HStack {
        LazyVGrid(columns: threeColumns) {
          Button("Clear all") {
            queryTerm = ""
            store.baseParams["filter[q]"] = queryTerm
            store.clearQueryFilters()
            store.fetchContents()
          }
          .buttonStyle(HeaderButtonStyle())
          ForEach(
            Array(
            store.domainFilters.merging(
              store.difficultyFilters) { _, second in second }
              .filter { $0.value }
              .keys), id: \.self) { key in
                Button(store.filtersDictionary[key]!) {
                  if Int(key) == nil {
                    store.difficultyFilters[key]!.toggle()
                  } else {
                    store.domainFilters[key]!.toggle()
                  }
                  store.fetchContents()
                }
                .buttonStyle(HeaderButtonStyle())
              }
        }
        Spacer()
      }
      HStack {
        Text("\(count) Episodes")
        Menu("\(Image(systemName: "filemenu.and.cursorarrow"))") {
          Button("10 results/page") {
            store.baseParams["page[size]"] = "10"
            store.fetchContents()
          }
          Button("20 results/page") {
            store.baseParams["page[size]"] = "20"
            store.fetchContents()
          }
          Button("30 results/page") {
            store.baseParams["page[size]"] = "30"
            store.fetchContents()
          }
          Button("No change") {
            
          }
        }
        Spacer()
        Picker("", selection: $sortOn) {
          Text("New").tag("new")
          Text("Popular").tag("popular")
        }
        .onChange(of: sortOn, perform: { _ in
          store.baseParams["sort"] = sortOn == "new" ? "-released_at" : "-popularity"
          store.fetchContents()
        })
        .pickerStyle(SegmentedPickerStyle())
        .frame(maxWidth: 130)
        .background(Color.gray.opacity(0.8))
      }
      .foregroundColor(Color.white.opacity(0.6))
    }
    .font(.subheadline)
    .foregroundColor(.white)
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity,
      alignment: .leading)
    .listRowInsets(EdgeInsets())
    .padding()
    .background(Color.topBkgd)
    .cornerRadius(32, corners: [.bottomLeft, .bottomRight])
    .background(Color.listBkgd)
  }
}

struct SearchField: View {
  @EnvironmentObject var store: EpisodeStore
  @Binding var queryTerm: String
  
  var body: some View {
    ZStack(alignment: .leading) {
      if queryTerm.isEmpty {
        Text("\(Image(systemName: "magnifyingglass")) Search videos")
          .foregroundColor(Color.white.opacity(0.6))
      }
      TextField("",
                text: $queryTerm,
                onEditingChanged: { _ in },
                onCommit: {
        store.baseParams["filter[q]"] = queryTerm
        store.fetchContents()
      }
      )
    }
    .padding(10)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(Color.white.opacity(0.2)))
  }
}

struct HeaderButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    HStack {
      Image(systemName: "xmark")
      configuration.label
    }
    .padding(6)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(Color.white.opacity(0.2))
    )
  }
}

struct HeaderView_Previews: PreviewProvider {
  static var previews: some View {
    HeaderView(count: 42)
      .environmentObject(EpisodeStore())
      .previewLayout(.sizeThatFits)
  }
}
