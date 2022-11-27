////
////  ContentView.swift
////  Flashzilla
////
////  Created by Michael Brockman on 11/9/22.
////
//
//import SwiftUI
//import CoreHaptics
//
//struct ContentView: View {
//  @Environment(\.scenePhase) var scenePhase
//  @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
//  @Environment(\.accessibilityReduceMotion) var reduceMotion
//  @State private var scale = 1.0
//  
//  var body: some View {
//    
//    Text("Hello, world!")
//      .scaleEffect(scale)
//      .onTapGesture {
//        withOptionalAnimation {
//          scale *= 1.5
//        }
//      }
//  }
//  
//  func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
//    if UIAccessibility.isReduceMotionEnabled {
//      return try body()
//    } else {
//      return try withAnimation(animation, body)
//    }
//  }
//}
////    HStack {
////      if differentiateWithoutColor {
////        Image(systemName: "checkmark.circle")
////      }
////
////      Text("Success")
////    }
////    .padding()
////    .background(differentiateWithoutColor ? .black : .pink)
////    .foregroundColor(.white)
////    .clipShape(Capsule())
//    
////    Text("Hello, world!")
////      .padding()
////      .onChange(of: scenePhase) { newPhase in
////        if newPhase == .active {
////          print("Active")
////        } else if newPhase == .inactive {
////          print("Inactive")
////        } else if newPhase == .background {
////          print("Background")
////        }
////      }
//  
//
//
//
////struct ContentView: View {
//////  @State private var engine: CHHapticEngine?
//////  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
////  let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
////
////  @State private var counter = 0
////
////  var body: some View {
////    Text("test")
////      .onReceive(timer) { time in
////        if counter == 5 {
////          timer.upstream.connect().cancel()
////        } else {
////          print("The time is now \(time)")
////
////        }
////        counter += 1
////      }
////  }
//  
//  
//  
//    //    VStack {
//    //      Text("Hello")
//    //      Spacer().frame(height: 100)
//    //      Text("World")
//    //    }
//    //    .contentShape(Rectangle())
//    //    .onTapGesture {
//    //      print("VStack tapped!")
//    //    }
//  
//    //    ZStack {
//    //      Rectangle()
//    //        .fill(.blue)
//    //        .frame(width: 300, height: 300)
//    //        .onTapGesture {
//    //          print("Rectangle tapped!")
//    //        }
//    //
//    //      Circle()
//    //        .fill(.red)
//    //        .frame(width: 300, height: 300)
//    //        .contentShape(Rectangle())
//    //        .onTapGesture {
//    //          print("Circle tapped!")
//    //        }
//  
//  
//  
//  
//  
//  
//  
//    //    Text("Hello, world!")
//    //      .onAppear { prepareHaptics() }
//    //      .onTapGesture { complexSuccess() }
//  
//  
//  
//  
//    //    VStack(spacing: 60) {
//    //      Text("Success button!")
//    //        .onTapGesture {
//    //          simpleSuccess()
//    //        }
//    //      Text("Error button!")
//    //        .onTapGesture {
//    //          simpleError()
//    //        }
//    //      Text("Warning button!")
//    //        .onTapGesture {
//    //          simpleWarning()
//    //        }
//    //    }
//  
//  
//    //  func simpleSuccess() {
//    //    let generator = UINotificationFeedbackGenerator()
//    //    generator.notificationOccurred(.success)
//    //  }
//    //
//    //  func simpleError() {
//    //    let generator = UINotificationFeedbackGenerator()
//    //    generator.notificationOccurred(.error)
//    //  }
//    //
//    //  func simpleWarning() {
//    //    let generator = UINotificationFeedbackGenerator()
//    //    generator.notificationOccurred(.warning)
//    //  }
//    //
//    //  func prepareHaptics() {
//    //    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
//    //
//    //    do {
//    //      engine = try CHHapticEngine()
//    //      try engine?.start()
//    //    } catch {
//    //      print("there was an error creating the haptics engine. \(error.localizedDescription)")
//    //    }
//    //  }
//    //
//    //  func complexSuccess() {
//    //    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
//    //    var events = [CHHapticEvent]()
//  
//    //    create one intense sharp tap
//    //    for i in stride(from: 0, to: 1, by: 0.1) {
//    //      let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
//    //      let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
//    //      let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
//    //      events.append(event)
//    //    }
//    //
//    //    for i in stride(from: 0, to: 1, by: 0.1) {
//    //      let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
//    //      let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
//    //      let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
//    //      events.append(event)
//    //    }
//    //    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
//    //    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
//    //    let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
//    //    events.append(event)
//  
//    //    do {
//    //      let pattern = try CHHapticPattern(events: events, parameters: [])
//    //      let player = try engine?.makePlayer(with: pattern)
//    //      try player?.start(atTime: 0)
//    //    } catch {
//    //      print("Failed to play pattern: \(error.localizedDescription)")
//    //    }
//  
//    //  }
//  
////}
//
//
//
////struct ContentView: View {
////  @State private var currentAmount = Angle.zero
////  @State private var finalAmount = Angle.zero
////
////  var body: some View {
////    Text("Hello, world!")
////      .rotationEffect(currentAmount + finalAmount)
////      .gesture(
////        RotationGesture()
////          .onChanged { angle in
////            currentAmount = angle
////          }
////          .onEnded { angle in
////            finalAmount += currentAmount
////            currentAmount = .zero
////          }
////
////      )
////  }
////}
//
////struct ContentView: View {
////  @State private var showAlert = false
////
////
////  @State private var currentAmount = 0.0
////  @State private var finalAmount = 1.0
////
////  var body: some View {
////    Text("Hello, world!")
////      .scaleEffect(finalAmount + currentAmount)
////      .gesture(
////        MagnificationGesture()
////          .onChanged { amount in
////            currentAmount = amount - 1
////          }
////          .onEnded { amount in
////            finalAmount += currentAmount
////            currentAmount = 0
////          }
////      )
////
////  }
////}
////    VStack {
////      Image(systemName: "globe")
////        .imageScale(.large)
////        .foregroundColor(.accentColor)
////      Text("Hello, world!")
////        .onLongPressGesture(minimumDuration: 1) {
////          print("Long pressed!")
////        } onPressingChanged: { inProgress in
////          print("In progress: \(inProgress)!")
////        }
////    }
////    .alert("Alert Triggered", isPresented: $showAlert) {
////      Button("OK", role: .cancel) { }
////    }
////    .padding()
////  }
//
//
//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView()
//  }
//}
