//
//  TimerView.swift
//  HIITFit
//
//  Created by Michael Brockman on 10/4/22.
//

import SwiftUI

struct TimerView: View {
  @State private var timeRemaining = 3
  
  @Binding var timerDone: Bool
  
  let timer = Timer.publish(every: 1, on: .main, in: .common)
    .autoconnect()
  
    var body: some View {
        Text("\(timeRemaining)")
        .font(.system(size: 90, design: .rounded))
        .padding()
        .onReceive(timer) { _ in
          if self.timeRemaining >= 1 {
            self.timeRemaining -= 1
          } else {
            timerDone = true
          }
          //ends the timer immediately at 0 rather than waiting a second and flashing
          if self.timeRemaining == 0 { timerDone = true }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
      TimerView(timerDone: .constant(false))
        .previewLayout(.sizeThatFits)
    }
}
