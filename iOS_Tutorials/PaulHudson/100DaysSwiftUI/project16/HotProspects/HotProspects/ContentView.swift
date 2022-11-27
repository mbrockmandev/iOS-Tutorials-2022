//
//  ContentView.swift
//  HotProspects
//
//  Created by Michael Brockman on 11/6/22.
//

import SwiftUI
import UserNotifications

struct ContentView_Previews: PreviewProvider {
  
  static var previews: some View {
    ContentView()
      .environmentObject(Prospects())
  }
}

struct ContentView: View {
  @StateObject var prospects = Prospects()
  
  
  var body: some View {
    TabView {
      ProspectsView(filter: .none)
        .tabItem {
          Label("Everyone", systemImage: "person.3")
        }
      ProspectsView(filter: .contacted)
        .tabItem {
          Label("Contacted", systemImage: "checkmark.circle")
        }
      ProspectsView(filter: .uncontacted)
        .tabItem {
          Label("Uncontacted", systemImage: "questionmark.diamond")
        }
      MeView()
        .tabItem {
          Label("Me", systemImage: "person.crop.square")
        }
    }.environmentObject(prospects)
  }
}


//struct ContentView: View {
//  let possibleNumbers = Array(1...60)
//  var results: String {
//    let selected = possibleNumbers.random(7).sorted()
//    let strings = selected.map(String.init)
//    return strings.joined(separator: ", ")
//  }
//
//  var body: some View {
//    Text(results)
//  }
//}

//struct ContentView: View {
//  var body: some View {
//    VStack {
//      Button("request permission") {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//          if success {
//            print("All set!")
//          } else if let error {
//            print(error.localizedDescription)
//          }
//        }
//      }
//      .buttonStyle(.borderedProminent)
//
//      Button("schedule notification") {
//        let content = UNMutableNotificationContent()
//        content.title = "Feed the dogs"
//        content.subtitle = "They look hungry"
//        content.sound = UNNotificationSound.default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request)
//      }
//      .buttonStyle(.borderedProminent)
//
//    }
//
//
//  }
//}

//struct ContentView6: View {
//  var body: some View {
//    List {
//      Text("Taytay swift")
//        .swipeActions {
//          Button(role: .destructive) {
//            print("Deleting")
//          } label: {
//            Label("Delete", systemImage: "minus.circle")
//          }
//        }
//        .swipeActions(edge: .leading) {
//          Button {
//            print("Pinning")
//          } label: {
//            Label("Pin", systemImage: "pin")
//          }
//          .tint(.orange)
//        }
//    }
//  }
//}

//struct ContentView: View {
//  @State private var backgroundColor = Color.red
//
//  var body: some View {
//    VStack {
//      Text("Hello world")
//        .padding()
//        .background(backgroundColor)
//
//      Text("Change Color")
//        .padding()
//        .contextMenu {
//          Button(role: .destructive) {
//            backgroundColor = .red
//          } label: {
//            Label("Red", systemImage: "checkmark.circle.fill")
//              .foregroundColor(.red)
//          }
//
//          Button {
//            backgroundColor = .green
//          } label: {
//          Label("Green", systemImage: "checkmark.circle.fill")
//        }
//          Button {
//            backgroundColor = .blue
//          } label: {
//            Label("Blue", systemImage: "checkmark.circle.fill")
//          }
//        }
//    }
//
//  }
//}


//struct ContentView5: View {
//  var body: some View {
//    Image("example")
//      .interpolation(.none)
//      .resizable()
//      .scaledToFit()
//      .frame(maxHeight: 250)
//      .background(.black)
//      .ignoresSafeArea()
//
//  }
//}


//struct ContentView4: View {
//  var body: some View {
//    Image("example")
//      .interpolation(.none)
//      .resizable()
//      .scaledToFit()
//      .frame(maxHeight: 250)
//      .background(.black)
//      .ignoresSafeArea()
//
//  }
//}

//struct ContentView3: View {
//  @State private var output = ""
//
//  var body: some View {
//    Text(output)
//      .task {
//        await fetchReadings()
//      }
//  }
//
//  func fetchReadings() async {
//    let fetchTask = Task { () -> String in
//      if let url = URL(string: "https://hws.dev/readings.json") {
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let readings = try JSONDecoder().decode([Double].self, from: data)
//        return "Found \(readings.count) readings."
//      } else {
//        return "Invalid URL."
//      }
//    }
//    let result = await fetchTask.result
    
    //way #1 of handling success/failure states
//    do {
//      output = try result.get()
//    } catch {
//      print("Invalid URL.")
//    }
    
    //way #2 of handling success/failure states
//    switch result {
//    case .success(let str):
//      output = str
//    case .failure(let error):
//      output = "Download error: \(error.localizedDescription)"
//    }
//  }
//}




//@MainActor class DelayedUpdater: ObservableObject {
//  var value = 0 {
//    willSet {
//      objectWillChange.send()
//    }
//  }
//
//  init() {
//    for i in 1...10 {
//      DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
//        self.value += 1
//      }
//    }
//  }
//}
//
//struct ContentView3: View {
//  @StateObject private var updater = DelayedUpdater()
//
//  var body: some View {
//    Text("Value is \(updater.value)")
//  }
//}
//
//@MainActor class User: ObservableObject {
//  @Published var name = "Taylor Swift"
//}
//
//struct EditView: View {
//  @EnvironmentObject var user: User
//
//  var body: some View {
//    TextField("Name", text: $user.name)
//  }
//}
//
//struct DisplayView: View {
//  @EnvironmentObject var user: User
//
//  var body: some View {
//    Text(user.name)
//  }
//}
//
//struct ContentView2: View {
//  @StateObject var user = User()
//
//  var body: some View {
//    VStack {
//      EditView()
//      DisplayView()
//    }
//    .environmentObject(user)
//    .padding()
//  }
//}
//
//struct TabViewExample: View {
//  @State private var selectedTab = "One"
//
//  var body: some View {
//
//    TabView(selection: $selectedTab) {
//      Text("Tab 1")
//        .onTapGesture {
//          selectedTab = "Two"
//        }
//        .tabItem {
//          Label("One", systemImage: "star")
//        }
//        .tag("One")
//      Text("Tab 2")
//        .tabItem {
//          Label("Two", systemImage: "circle")
//        }
//        .tag("Two")
//    }
//  }
//}

