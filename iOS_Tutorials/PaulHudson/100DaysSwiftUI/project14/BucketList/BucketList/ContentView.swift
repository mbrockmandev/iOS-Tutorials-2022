  //
  //  ContentView.swift
  //  BucketList
  //
  //  Created by Michael Brockman on 11/1/22.
  //

import SwiftUI
import MapKit

struct ContentView: View {
  @StateObject private var viewModel = ViewModel()
  
  var body: some View {
    if viewModel.isUnlocked {
      ZStack {
        Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
          MapAnnotation(coordinate: location.coordinate) {
            VStack {
              Image(systemName: "star.circle")
                .resizable()
                .foregroundColor(.red)
                .frame(width: 44, height: 44)
                .background(.white)
                .clipShape(Circle())
              
              Text(location.name)
                .fixedSize()
            }
            .onTapGesture {
              viewModel.selectedPlace = location
            }
          }
        }
        .ignoresSafeArea()
        
        Circle()
          .fill(.blue)
          .opacity(0.3)
          .frame(width: 32, height: 32)
        
        VStack {
          Spacer()
          
          HStack {
            Spacer()
            
            Button {
              viewModel.addLocation()
            } label: {
              Image(systemName: "plus")
                .padding()
                .background(.black.opacity(0.75))
                .foregroundColor(.white)
                .font(.title)
                .clipShape(Circle())
                .padding(.trailing)
            }
          }
        }
      }
      .sheet(item: $viewModel.selectedPlace) { place in
        EditView(location: place) { newLocation in
          viewModel.update(location: newLocation)
        }
      }
    } else {
      Button("Unlock Places") {
        viewModel.authenticate()
      }
      .padding()
      .background(.blue)
      .foregroundColor(.white)
      .clipShape(Capsule())
      .alert("Authentication Error", isPresented: $viewModel.isShowingAuthenticationError) {
        Button("OK") { }
      } message: {
        Text(viewModel.authenticationError)
      }
    }
  }
  
  
//  var body: some View {
//    if viewModel.isUnlocked {
//      ZStack {
//        Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
//          MapAnnotation(coordinate: location.coordinate) {
//            VStack {
//              Image(systemName: "star.circle")
//                .resizable()
//                .foregroundColor(.red)
//                .frame(width: 44, height: 44)
//                .background(.white)
//                .clipShape(Circle())
//
//              Text(location.name)
//                .fixedSize()
//            }
//            .onTapGesture {
//              viewModel.selectedPlace = location
//            }
//          }
//        }
//        .ignoresSafeArea()
//        Circle()
//          .fill(.blue)
//          .opacity(0.3)
//          .frame(width: 32, height: 32)
//        VStack {
//          Spacer()
//          HStack {
//            Spacer()
//            Button {
//              viewModel.addLocation()
//            } label: {
//              Image(systemName: "plus")
//            }
//            .padding()
//            .background(.black.opacity(0.75))
//            .foregroundColor(.white)
//            .font(.title)
//            .clipShape(Circle())
//            .padding(.trailing)
//
//          }
//        }
//      }
//      .sheet(item: $viewModel.selectedPlace) { place in
//        EditView(location: place) {
//          viewModel.update(location: $0)
//        }
//      }
//    } else {
//      Button("Unlock Places") {
//        viewModel.authenticate()
//      }
//      .padding()
//      .background(.blue)
//      .foregroundColor(.white)
//      clipShape(Capsule())
//    }
//  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

  //==========EXAMPLE CODE=======
  //  var body: some View {
  //    VStack {
  //
  //      if isUnlocked {
  //        Text("Unlocked")
  //      } else {
  //        Text("Locked")
  //      }
  //
  //
  //      NavigationView {
  //      Text("Hello, world!")
  //        .onTapGesture {
  //          let str = "Test Message"
  //          let url = getDocumentsDirectory().appendingPathComponent("message.txt")
  //
  //          do {
  //            try str.write(to: url, atomically: true, encoding: .utf8)
  //            let input = try String(contentsOf: url)
  //            print(input)
  //
  //          } catch {
  //            print(error.localizedDescription)
  //          }
  //        }
  //        Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
  //          MapAnnotation(coordinate: location.coordinate) {
  //            NavigationLink {
  //              Text(location.name)
  //            } label: {
  //              Circle()
  //                .stroke(.red, lineWidth: 3)
  //                .frame(width: 44, height: 44)
  //                .onTapGesture {
  //                  print("Tapped on \(location.name)")
  //                }
  //            }
  //          }
  //
  //            //        MapMarker(coordinate: location.coordinate)
  //
  //        }
  //        .navigationTitle("London Explorer")
  //      }
  //      .padding()
  //    }
  //    .onAppear(perform: authenticate)
  //  }

  //  func getDocumentsDirectory() -> URL {
  //    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  //
  //    return paths[0]
  //  }
  //
  //  func authenticate() {
  //    let context = LAContext()
  //    var error: NSError?
  //
  //    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
  //      let reason = "We need to unlock your data."
  //
  //      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
  //        if success {
  //          viewModel.isUnlocked = true
  //        } else {
  //            //there was an error
  //        }
  //      }
  //    } else {
  //        //no biometrics
  //    }
  //  }

  //  enum LoadingState {
  //    case loading, success, failed
  //  }


