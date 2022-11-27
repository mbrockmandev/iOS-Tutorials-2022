  //
  //  MeView.swift
  //  HotProspects
  //
  //  Created by Michael Brockman on 11/7/22.
  //

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
  @EnvironmentObject var prospects: Prospects //remove in final version
  @State private var name = "Anonymous"
  @State private var emailAddress = "you@youremail.com"
  @State private var qrCode = UIImage()
  
  let context = CIContext()
  let filter = CIFilter.qrCodeGenerator()
  
  var body: some View {
    NavigationView {
      Form {
        TextField("Name", text: $name)
          .textContentType(.name)
          .font(.title)
        
        TextField("Email Address", text: $emailAddress)
          .textContentType(.emailAddress)
          .font(.title)
        
        Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
          .interpolation(.none)
          .resizable()
          .scaledToFit()
          .frame(width: 200, height: 200)
          .contextMenu {
            Button {
              let imageSaver = ImageSaver()
              imageSaver.writeToPhotoAlbum(image: qrCode)
            } label: {
              Label("Save to Photos", systemImage: "square.and.arrow.down")
            }

          }
          
      }
      .navigationTitle("Your code")
      .toolbar {
        Button {
          addPersonManually()
        } label: {
          Text("ADD")
        }
      }
      .onAppear(perform: updateCode)
      .onChange(of: name) { _ in updateCode() }
      .onChange(of: emailAddress) {_ in updateCode() }
    }
  }
  
  func addPersonManually() {
    let newPerson = Prospect()
    newPerson.name = name
    newPerson.emailAddress = name
    prospects.add(newPerson)
  }
  
  func generateQRCode(from string: String) -> UIImage {
    filter.message = Data(string.utf8)
    
    if let outputImage = filter.outputImage {
      if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
        return UIImage(cgImage: cgimg)
      }
    }
    return UIImage(systemName: "xmark.circle") ?? UIImage()
  }
  
  func updateCode() {
    qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
  }
}
