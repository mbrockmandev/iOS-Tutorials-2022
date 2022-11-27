//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Michael Brockman on 11/12/22.
//

import SwiftUI



struct ContentView: View {
  var resorts: [Resort] = Bundle.main.decode("resorts.json")
  
  @StateObject var favorites = Favorites()
  @State private var searchText = ""
  @State private var showSortingDialog = false
  @State private var sortingOption: SortingType = .runs
  
  enum SortingType {
    case runs, alphabetical, country
  }
  
  var body: some View {
    NavigationView {
      List(sortedResorts) { resort in
        NavigationLink {
          ResortView(resort: resort)
        } label: {
          
          HStack {
            Image(resort.country)
              .resizable()
              .scaledToFill()
              .frame(width: 40, height: 25)
              .clipShape(
                RoundedRectangle(cornerRadius: 5)
              )
              .overlay(
                RoundedRectangle(cornerRadius: 5)
                  .stroke(.black, lineWidth: 1)
              )
            
            VStack(alignment: .leading) {
              Text(resort.name)
                .font(.headline)
              Text("\(resort.runs) runs")
                .foregroundColor(.secondary)
            }
            
            if favorites.contains(resort) {
              Spacer()
              Image(systemName: "heart.fill")
                .accessibilityLabel("This is a favorite resort")
                .foregroundColor(.red)
            }
          }
        }
      }
      .navigationTitle("Resorts")
      .toolbar {
        Button {
          showSortingDialog = true
        } label: {
          Image(systemName: "arrow.up.arrow.down")
        }
      }
      .searchable(text: $searchText, prompt: "Search for a resort")
      .confirmationDialog("Sort by…", isPresented: $showSortingDialog) {
        Button("Name") {
          sortingOption = .alphabetical
        }
        Button("Country") {
          sortingOption = .country
        }
        Button("# Runs") {
          sortingOption = .runs
        }
      }
      
      WelcomeView()
    }
    .environmentObject(favorites)
      //    .phoneOnlyStackNavigationView() //can be used for an alternate layout for landscape max size phones
  }
  
  var filteredResorts: [Resort] {
    if searchText.isEmpty {
      return resorts
    } else {
      return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
  }
  
  var sortedResorts: [Resort] {
    switch sortingOption {
      
    case .runs:
      return filteredResorts.sorted {
        $0.runs > $1.runs
      }
    case .alphabetical:
      return filteredResorts.sorted {
        $0.name < $1.name
      }
    case .country:
      return filteredResorts.sorted {
        $0.country < $1.country
      }
    }
  }
  
    //func sort(by sortingOption: String) {
    //  var sortByName = false
    //  var sortByCountry = false
    //
    //  switch sortingOption.lowercased() {
    //  case "name":
    //    sortByName = true
    //  case "country":
    //    sortByCountry = true
    //  default:
    //    return
    //  }
    //
    //  if sortByName {
    //    resorts.sort {
    //      $0.name < $1.name
    //    }
    //  } else if sortByCountry {
    //    resorts.sort {
    //      $0.country < $1.country
    //    }
    //  }
    //  }
  
  
//  var filteredNames: [String] {
//    if searchText.isEmpty {
//      return allNames
//    } else {
//      var newArray = [String]()
//      for name in allNames {
//        if name.lowercased().contains(searchText.lowercased()) {
//          newArray.append(name)
//        }
//      }
//      return newArray
//    }
//  }
}

//struct ContentView: View {
//  @State private var searchText = ""
//
//  var body: some View {
//    NavigationView {
//      Text("Searching for \(searchText)")
//        .searchable(text: $searchText, prompt: "Look for something")
//        .navigationTitle("Searching")
//    }
//  }
//}

//struct ContentView: View {
//  @Environment(\.horizontalSizeClass) var sizeClass
//
//  var body: some View {
//    if sizeClass == .compact {
//      VStack(content: UserView.init)
//    } else {
//      HStack(content: UserView.init)
//    }
//  }
//}


//struct ContentView: View {
//  @State private var layoutVertically = false
//
//  var body: some View {
//    Group {
//      if layoutVertically {
//        VStack {
//          UserView()
//        }
//      } else {
//        HStack {
//          UserView()
//        }
//      }
//    }
//    .onTapGesture {
//      layoutVertically.toggle()
//    }
//  }
//}

//struct ContentView: View {
//  @State private var selectedUser: User? = nil
//  @State private var isShowingUser = false
//
//    var body: some View {
//
//      Text("Hello world")
//        .onTapGesture {
//          selectedUser = User()
//        }
//        .sheet(item: $selectedUser) { user in
//          Text(user.id)
//        }
//        .alert("Welcome", isPresented: $isShowingUser, presenting: selectedUser) { user in
//          Button(user.id) { }
//        }
//    }
//}

//struct UserView: View {
//  var body: some View {
//    Group {
//      Text("Name: Paul")
//      Text("Country: England")
//      Text("Pets: Luna and Arya")
//    }
//    .font(.title)
//  }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
