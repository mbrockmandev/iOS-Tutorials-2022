//
//  View-Ext.swift
//  SnowSeeker
//
//  Created by Michael Brockman on 11/13/22.
//

import SwiftUI

extension View {
  @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
    if UIDevice.current.userInterfaceIdiom == .phone {
      self.navigationViewStyle(.stack)
    } else {
      self
    }
  }
}
