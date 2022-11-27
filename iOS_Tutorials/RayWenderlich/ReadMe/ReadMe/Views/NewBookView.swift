  //
  //  AddNewBookView.swift
  //  ReadMe
  //
  //  Created by Michael Brockman on 8/27/22.
  //

import SwiftUI
import class PhotosUI.PHPickerViewController

struct NewBookView: View {
  @ObservedObject var book: Book = Book(title: "", author: "")
  @State var image: Image? = nil
  @EnvironmentObject var library: Library
  @Environment(\.dismiss) var dismiss
  
  @State var showingImagePicker = false
  @State var showingDeleteDialog = false
  
  
  var body: some View {
    NavigationView {
      VStack(spacing: 24) {
        TextField("Title", text: $book.title)
        TextField("Author", text: $book.author)
        ReviewAndImageStack(book: book, image: image)
      }
      .padding()
      .navigationTitle("Got a new book?")
      .toolbar {
        ToolbarItem(placement: .status) {
          Button("Add to Library") {
            library.addNewBook(book, image: image)
            dismiss()
          }
          .disabled(
            [book.title, book.author]
              .contains(where: \.isEmpty)
          )
        }
      }
    }
  }
}
struct NewBookView_Previews: PreviewProvider {
  static var previews: some View {
    NewBookView()
      .previewedInAllColorSchemes
      .environmentObject(Library())
  }
}
