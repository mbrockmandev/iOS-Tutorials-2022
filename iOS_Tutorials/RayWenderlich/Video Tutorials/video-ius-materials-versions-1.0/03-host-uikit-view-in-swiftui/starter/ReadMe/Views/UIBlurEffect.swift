import SwiftUI
import UIKit

// TODO: - Add UIBlurEffect!
public extension UIBlurEffect {
  struct View {
    let blurStyle: Style
  }
}


//MARK: - UIViewRepresentable
extension UIBlurEffect.View: UIViewRepresentable {
  public func updateUIView(_ uiView: UIViewType, context: Context) {}
  
  public func makeUIView(context: Context) -> some UIView {
    UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
  }
}
