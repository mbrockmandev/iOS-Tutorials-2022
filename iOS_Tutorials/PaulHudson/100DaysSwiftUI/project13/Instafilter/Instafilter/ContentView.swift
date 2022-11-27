  //
  //  ContentView.swift
  //  Instafilter
  //
  //  Created by Michael Brockman on 10/30/22.
  //

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
  @State private var image: Image?
  @State private var filterIntensity      = 0.5
  @State private var filterRadius         = 1.0
  @State private var showingImagePicker   = false
  @State private var showingFilterSheet   = false
  @State private var isSaveButtonDisabled = true
  @State private var inputImage: UIImage?
  @State private var processedImage: UIImage?
  @State private var currentFilter: CIFilter  = CIFilter.sepiaTone()
  @State private var filterLabel: String      = "Change Filter" // consider changing so label can update
  let context = CIContext() // only declare once as it is expensive

  
  var body: some View {
    ZStack {
      Color.pink
        .ignoresSafeArea()
      
      NavigationView {
        VStack {
          ZStack {
            Rectangle()
              .fill(.secondary)
            
            Text("Tap to select a picture")
              .foregroundColor(.white)
              .font(.headline)
            
            image?
              .resizable()
              .scaledToFit()
          }
          .onTapGesture {
            showingImagePicker = true
          }
          
          if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
            HStack {
              Text("Radius")
              Slider(value: $filterRadius)
                .onChange(of: filterRadius) { _ in
                  applyProcessing()
                }
            }
            .padding(.top)
            
          }
          
          if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
            HStack {
              Text("Intensity")
              Slider(value: $filterIntensity)
                .onChange(of: filterIntensity) { _ in
                  applyProcessing()
                }
            }
            .padding(.bottom)
          }
          HStack {
            
            Button(filterLabel) {
              showingFilterSheet = true
            }
            
            Spacer()
            
            Button("Save", action: save)
              .disabled(isSaveButtonDisabled)
          }
          
        }
        .padding([.horizontal, .bottom])
        .navigationTitle("InstaFilter")
        .onChange(of: inputImage) { _ in loadImage() }
        .sheet(isPresented: $showingImagePicker) {
          ImagePicker(image: $inputImage)
        }
        .popover(isPresented: $showingFilterSheet, content: {
          VStack(spacing: 6) {
            Text("Pick a Filter:")
            Button("Crystallize")   { setFilter(CIFilter.crystallize()) }
            Button("Pointillize")   { setFilter(CIFilter.pointillize()) }
            Button("Bloom")         { setFilter(CIFilter.bloom()) }
            Button("Photo Noir")    { setFilter(CIFilter.photoEffectNoir()) }
            Button("Edges")         { setFilter(CIFilter.edges()) }
          }
          VStack(spacing: 6) {
            Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
            Button("Pixellate")     { setFilter(CIFilter.pixellate()) }
            Button("Sepia Tone")    { setFilter(CIFilter.sepiaTone()) }
            Button("Unsharp Mask")  { setFilter(CIFilter.unsharpMask()) }
            Button("Vignette")      { setFilter(CIFilter.vignette()) }
            Button("Cancel", role: .cancel) { }
          }
        })
      }
    }
  }
  
//  enum filterTypes: String {
//    case crystallize  = "Crystallize"
//    case pointillize  = "Pointillize"
//    case bloom        = "Bloom"
//    case photoNoir    = "Photo Noir"
//    case edges        = "Edges"
//    case gaussianBlur = "Gaussian Blur"
//    case pixellate    = "Pixellate"
//    case sepiaTone    = "Sepia Tone"
//    case unsharpMark  = "Unsharp Mask"
//    case vignette     = "Vignette"
//  }
  
  func loadImage() {
    guard let inputImage else { return }
    
    let beginImage = CIImage(image: inputImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    applyProcessing()
  }
  
  func save() {
    guard let processedImage else { return }
    let imageSaver = ImageSaver()
    
    imageSaver.successHandler = {
      print("Success!")
    }
    
    imageSaver.errorHandler = {
      print("Oops: \($0.localizedDescription)")
    }
    
    imageSaver.writeToPhotoAlbum(image: processedImage)
  }
  
  func setFilter(_ filter: CIFilter) {
    currentFilter = filter
    loadImage()
    showingFilterSheet = false
  }
  
  func applyProcessing() {
    let inputKeys = currentFilter.inputKeys
    
    if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)}
    if inputKeys.contains(kCIInputRadiusKey)    { currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)}
    if inputKeys.contains(kCIInputScaleKey)     { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)}
    
    guard let outputImage = currentFilter.outputImage else { return }
    
    if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
      let uiImage = UIImage(cgImage: cgimg)
      image = Image(uiImage: uiImage)
      processedImage = uiImage
      isSaveButtonDisabled = false
    }
  }
}

/*
 struct ContentView2: View {
 @State private var image: Image?
 @State private var inputImage: UIImage?
 @State private var showingImagePicker = false
 
 var body: some View {
 VStack {
 image?
 .resizable()
 .scaledToFit()
 
 Button("Select Image") {
 showingImagePicker = true
 }
 
 Button("Save Image") {
 guard let inputImage else { return }
 let imageSaver = ImageSaver()
 imageSaver.writeToPhotoAlbum(image: inputImage)
 }
 }
 .sheet(isPresented: $showingImagePicker) {
 ImagePicker(image: $inputImage)
 }
 .onChange(of: inputImage) { _ in loadImage() }
 .padding()
 }
 
 func loadImage() {
 guard let inputImage else { return }
 image = Image(uiImage: inputImage)
 
 //Parameters:
 //1- image to save, 2- object to notified about result of save,
 //3- method to run, 4- data passed back when method is completed ("context") -- in the form of a raw pointer
 
 }
 }
 */

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
