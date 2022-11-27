import SwiftUI

struct TextPicker: View {
  @Environment(\.presentationMode) var presentationMode
  @Binding var textElement: TextElement

  var body: some View {
    let onCommit = {
      presentationMode.wrappedValue.dismiss()
    }
    VStack {
      TextField(
        "Enter text", text: $textElement.text, onCommit: onCommit)
      .font(.custom(textElement.textFont, size: 30))
      .foregroundColor(textElement.textColor)
      TextView(font: $textElement.textFont, color: $textElement.textColor)
    }
  }
}

struct TextPicker_Previews: PreviewProvider {
  @State static var textElement = TextElement()
  @State static var font = "San Francisco"
  @State static var color = Color("appColor1")
  static var previews: some View {
    TextPicker(textElement: $textElement)
  }
}
