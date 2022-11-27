//
//  ReviewAndImageStack.swift
//  ReadMe
//
//  Created by Michael Brockman on 8/27/22.
//

import SwiftUI
import class PhotosUI.PHPickerViewController

struct ReviewAndImageStack: View {
  @ObservedObject var book: Book = Book(title: "", author: "")
  @State var image: Image? = nil
  @State var showingImagePicker = false
  @State var showingDeleteDialog = false
  
  var body: some View {
    VStack {
      
      Divider()
        .padding(.vertical)
      TextField("Enter a micro review:", text: $book.microReview)
        .padding(.vertical)
      Divider()
      
      Book.Image(image: image, title: book.title, cornerRadius: 16)
        .scaledToFit()
      
      HStack() {
        Spacer()
        if image != nil {
          Button("Delete Image") {
            showingDeleteDialog = true
          }
          .confirmationDialog(
            "Delete image for \(book.title)?",
            isPresented: $showingDeleteDialog) {
              Button("Delete", role: .destructive) {
                image = nil
                showingDeleteDialog = false
              }
              
            } message: {
              Text("Delete image for \(book.title)?")
            }
          Spacer()
        }
        Button("Update Image…") {
          showingImagePicker = true
        }
        .padding()
        Spacer()
      }
      Spacer()
        .sheet(isPresented: $showingImagePicker) {
          PHPickerViewController.View(image: $image)
        }
    }
    
  }
}


struct ReviewAndImageStack_Previews: PreviewProvider {
    static var previews: some View {
      ReviewAndImageStack()
        .padding(.horizontal)
        .previewedInAllColorSchemes
    }
}
