  //
  //  ContentView.swift
  //  Bookworm
  //
  //  Created by Michael Brockman on 10/20/22.
  //

import SwiftUI

struct ContentView: View {
  @Environment(\.managedObjectContext) var moc
  @FetchRequest(sortDescriptors: [
    SortDescriptor(\.title),
    SortDescriptor(\.author)
  ]) var books: FetchedResults<Book>

  @State private var showingAddScreen = false
  
  var body: some View {
    NavigationView {
      List {
        ForEach(books) { book in
          NavigationLink {
            DetailView(book: book)
          } label: {
            HStack {
              EmojiRatingView(rating: book.rating)
                .font(.largeTitle)
                
              VStack(alignment: .leading) {
                Text(book.title ?? "Unknown Title")
                  .font(.headline)
                  .foregroundColor(book.rating == 1 ? .red : .primary)
                Text(book.author ?? "Unknown Author")
                  .foregroundColor(.secondary)
              }
            }
          }
        }
        .onDelete(perform: deleteBooks)
      }
      .navigationTitle("Bookworm")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          EditButton()
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            showingAddScreen.toggle()
          } label: {
            Label("Add Book", systemImage: "plus")
          }
        }
      }
      .sheet(isPresented: $showingAddScreen) {
        AddBookView()
      }
    }
  }
  
  func deleteBooks(at offsets: IndexSet) {
    for offset in offsets {
      let book = books[offset]
      moc.delete(book)
    }
    try? moc.save()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

//struct ContentView4: View {
//  @Environment(\.managedObjectContext) var moc
//  @AppStorage("notes") private var notes = ""
//  @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student>
//
//  var body: some View {
//
//    VStack {
//      List(students) { student in
//        Text(student.name ?? "Unknown")
//      }
//      Button("Add") {
//        let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
//        let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]
//
//        let chosenFirstName = firstNames.randomElement() ?? "Harry"
//        let chosenLastName = lastNames.randomElement() ?? "Plopper"
//
//        let student = Student(context: moc)
//        student.id = UUID()
//        student.name = "\(chosenFirstName) \(chosenLastName)"
//        try? moc.save()
//      }
//    }
//
//
//    NavigationView {
//      TextEditor(text: $notes)
//        .navigationTitle("Notes")
//        .padding()
//
//    }
//  }
//}


//struct ContentView3: View {
//
//  @State private var rememberMe = false
//  var body: some View {
//    VStack {
//      PushButton(title: "Remember Me", isOn: $rememberMe)
//      Text(rememberMe ? "On" : "Off")
//    }
//    .padding()
//  }
//}
//
//struct ContentView2: View {
//  @State private var rememberMe = false
//
//  var body: some View {
//    Toggle("Remember me", isOn: $rememberMe)
//  }
//}

//struct PushButton: View {
//  let title: String
//  @Binding var isOn: Bool
//
//  var onColors = [Color.red, Color.yellow]
//  var offColors = [Color(white: 0.6), Color(white: 0.4)]
//
//  var body: some View {
//    Button(title) {
//      isOn.toggle()
//    }
//    .padding()
//    .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors), startPoint: .top, endPoint: .bottom))
//    .foregroundColor(.white)
//    .clipShape(Capsule())
//    .shadow(radius: isOn ? 0 : 5)
//  }
//}

