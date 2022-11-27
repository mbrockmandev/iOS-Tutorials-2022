  //
  //  ContentView.swift
  //  ReadMe
  //
  //  Created by Michael Brockman on 8/23/22.
  //

import SwiftUI
//import AVFAudio

struct ContentView: View {
  @State var addNewBook = false
  @EnvironmentObject var library: Library
  
  var body: some View {
    NavigationView {
      List {
        Button {
          addNewBook = true
        } label: {
          Spacer()
          VStack(spacing: 6) {
            Image(systemName: "book.circle")
              .font(.system(size: 60))
            Text("Add new book")
              .font(.title2)
          }
          Spacer()
        }
        .buttonStyle(.borderless)
        .padding(.vertical, 8)
        .sheet(isPresented: $addNewBook, content: NewBookView.init)
        
        ForEach(Section.allCases, id: \.self) {
          SectionView(section: $0)
        }
        .navigationTitle("My Library")
      }
      .listStyle(.insetGrouped)
      .toolbar(content: EditButton.init)
    }
  }
}

private struct BookRow: View {
  @ObservedObject var book: Book
  @EnvironmentObject var library: Library
  
  var body: some View {
    NavigationLink(destination: DetailView(book: book)) {
      HStack(alignment: .center) {
        Book.Image(image: library.images[book], title: book.title, size: 80, cornerRadius: 12)
        VStack(alignment: .leading) {
          TitleAndAuthorStack(book: book, titleFont: .title2, authorFont: .title3)
          
          
          if !book.microReview.isEmpty {
            Spacer()
            Text(book.microReview)
              .font(.subheadline)
              .foregroundColor(.secondary)
          }
        }
      }
      .lineLimit(1)
    }
    .padding(.vertical)
    
  }
}

private struct SectionView: View {
  let section: Section
  @EnvironmentObject var library: Library
  
  var title: String {
    switch section {
    case .readMe:
      return "Read Me!"
    case .finished:
      return "Finished!"
    }
  }
  
  var body: some View {
    if let books = library.sortedBooks[section] {
      SwiftUI.Section {
        ForEach(books) { book in
          BookRow(book: book)
            .swipeActions(edge: .leading) {
              Button {
                withAnimation {
                  book.readMe.toggle()
                }
              } label: {
                book.readMe
                ? Label("Finished", systemImage: "bookmark.slash")
                : Label("Read Me!", systemImage: "bookmark")
              }
              
            }
            .swipeActions(edge: .trailing) {
              Button(role: .destructive) {
                guard let index = books.firstIndex(where: {$0.id == book.id}) else { return }
                
                withAnimation {
                  library.deleteBooks(atOffsets: .init(integer: index), section: section)
                }
              } label: {
                Label("Delete", systemImage: "trash")
              }
            }
            .tint(.red)
        }
        .onDelete{ indexSet in
          library.deleteBooks(atOffsets: indexSet, section: section)
        }
        .onMove { indexes, newOffset in
          library.moveBooks(oldOffsets: indexes, newOffset: newOffset, section: section)
        }
        
        .labelStyle(.iconOnly)
      } header: {
        ZStack {
          Image("BookTexture")
            .resizable()
            .scaledToFit()
          
          Text(title)
            .font(.custom("American Typewriter", size: 24))
            .foregroundColor(.primary)
        }
        .listRowInsets(.init())
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .previewedInAllColorSchemes
      .environmentObject(Library())
  }
}

