  //
  //  ContentView.swift
  //  Drawing
  //
  //  Created by Michael Brockman on 10/16/22.
  //

import SwiftUI

struct ContentView: View {
  @State private var arrowThickness = 1.0
  @State private var gradientX: CGFloat = 0
  @State private var gradientY: CGFloat = 0
  
  var body: some View {
    VStack {
      Arrow()
        .stroke(.red, style: StrokeStyle(lineWidth: arrowThickness, lineCap: .round))
        
        .onTapGesture {
          withAnimation {
            arrowThickness = Double.random(in: 3.0...10.0)
          }
        }
        .frame(width: 300, height: 500)
      
      Text("Thickness")
      Slider(value: $arrowThickness, in: 1.0...25.0)
      
    }
    
    VStack {
      ColorCyclingRectangle(gradientX: gradientX, gradientY: gradientY)
      
      Text("Gradient X")
      Slider(value: $gradientX)
      Text("Gradient Y")
      Slider(value: $gradientY)
    }
    
  }
}

struct ColorCyclingRectangle: View {
  var amount = 0.0
  var steps = 100
  var gradientX: CGFloat
  var gradientY: CGFloat
  
  var body: some View {
    ZStack {
      ForEach(0..<steps) { value in
        Rectangle()
          .inset(by: Double(value))
          .strokeBorder(
            LinearGradient(
            gradient:
              Gradient(
                colors: [
                  color(for: value, brightness: 1),
                  color(for: value, brightness: 0.5)]),
            startPoint: UnitPoint(x: gradientX * 0.1, y: gradientY * 0.1),
            endPoint: UnitPoint(x: gradientX, y: gradientY)),
            lineWidth: 2)
          //          .strokeBorder(color(for: value, brightness: 1), lineWidth: 2)
      }
    }
    .drawingGroup()
  }
  
  func color(for value: Int, brightness: Double) -> Color {
    var targetHue = Double(value) / Double(steps) + amount
    
    if targetHue > 1 {
      targetHue -= 1
    }
    
    return Color(hue: targetHue, saturation: 1, brightness: brightness)
    
  }
  
  
}

struct Arrow: InsettableShape {
  var thickness = 0.0
  
  var animatableData: Double {
    get { thickness }
    set { thickness = newValue }
  }
  
  func inset(by amount: CGFloat) -> some InsettableShape {
    var line = self
    line.thickness += amount
    return line
  }
  
  func path(in rect: CGRect) -> Path {
    
    var path = Path()
    
    path.move(to: CGPoint(x: rect.midX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
    path.addLine(to: CGPoint(x: rect.maxX / 3, y: rect.midY))
    path.addLine(to: CGPoint(x: rect.maxX / 3, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX / 1.5, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX / 1.5, y: rect.midY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
    path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
    path.closeSubpath()
    
    
    return path
  }
}


struct Checkerboard: Shape {
  var rows: Int
  var columns: Int
  
  var animatableData: AnimatablePair<Double, Double> {
    get {
      AnimatablePair(Double(rows), Double(columns))
    }
    
    set {
      rows = Int(newValue.first)
      columns = Int(newValue.second)
    }
  }
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let rowSize = rect.height / Double(rows)
    let columnSize = rect.width / Double(columns)
    
    for row in 0..<rows {
      for column in 0..<columns {
        if (row + column).isMultiple(of: 2) {
          let startX = columnSize * Double(column)
          let startY = rowSize * Double(row)
          
          let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
          path.addRect(rect)
        }
      }
    }
    return path
  }
}


struct Trapezoid: Shape {
  var insetAmount: Double
  
  var animatableData: Double {
    get { insetAmount }
    set { insetAmount = newValue }
  }
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: 0, y: rect.maxY))
    path.addLines([
      CGPoint(x: insetAmount, y: rect.minY),
      CGPoint(x: rect.maxX - insetAmount, y: rect.minY),
      CGPoint(x: rect.maxX, y: rect.maxY),
      CGPoint(x: 0, y: rect.maxY)
    ])
    
    return path
  }
}

struct ContentView5: View {
  @State private var insetAmount = 50.0
  
  var body: some View {
    Trapezoid(insetAmount: insetAmount)
      .frame(width: 200, height: 100)
      .onTapGesture {
        withAnimation {
          insetAmount = Double.random(in: 10...90)
        }
      }
  }
}

  //special effects in swiftui: blurs, blending, and more
struct ContentView4: View {
  @State private var radius = 0.0
  @State private var saturationAmt = 0.0
  @State private var blurAmt = 0.0
  
  var body: some View {
    VStack {
      ZStack {
        Circle()
          .fill(.red)
          .frame(width: 200 * radius)
          .offset(x: -50, y: -80)
          .blendMode(.screen)
        
        Circle()
          .fill(.green)
          .frame(width: 200 * radius)
          .offset(x: 50, y: -80)
          .blendMode(.screen)
        
        Circle()
          .fill(.blue)
          .frame(width: 200 * radius)
          .blendMode(.screen)
      }
      .frame(width: 300, height: 300)
      .saturation(saturationAmt)
      .blur(radius: (1-blurAmt) * 20)
      
      VStack(spacing: 5) {
        Text("Radius")
          .foregroundColor(.white)
        Slider(value: $radius)
        
        Text("Saturation")
          .foregroundColor(.white)
        Slider(value: $saturationAmt)
        
        Text("Blur")
          .foregroundColor(.white)
        Slider(value: $blurAmt)
        
      }
      
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.black)
    .ignoresSafeArea()
    
    
    
    
    
  }
}


struct ContentView3: View {
  @State private var colorCycle = 0.0
  
  var body: some View {
    VStack {
      ColorCyclingCircle(amount: colorCycle)
        .frame(width: 300, height: 300)
      Spacer()
      Text("colorcycle")
      Slider(value: $colorCycle)
    }
    .frame(height: 500)
    
  }
  
}

struct ContentView2: View {
  @State private var petalOffset = -20.0
  @State private var petalWidth = 100.0
  @State private var strokeLineWidth = 1.0
  
  var body: some View {
    VStack {
      Flower(petalOffset: petalOffset, petalWidth: petalWidth)
        .fill(.red, style: FillStyle(eoFill: true))
        //            .stroke(.red, lineWidth: strokeLineWidth)
      
      Text("Offset")
      Slider(value: $petalOffset, in: -40...40)
        .padding([.horizontal, .bottom])
      
      Text("Width")
      Slider(value: $petalWidth, in: 0...100)
        .padding([.horizontal, .bottom])
        //          Text("Line Width")
        //          Slider(value: $strokeLineWidth, in: 1...25)
        //            .padding(.horizontal)
    }
    .padding()
    .preferredColorScheme(.dark)
    
  }
}

struct Triangle: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: rect.midX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
    
    return path
  }
}

struct Arc: InsettableShape {
  var startAngle: Angle
  var endAngle: Angle
  var clockwise: Bool
  var insetAmount = 0.0
  
  func path(in rect: CGRect) -> Path {
    let rotationAdjustment = Angle.degrees(90)
    let modifiedStart = startAngle - rotationAdjustment
    let modifiedEnd = endAngle - rotationAdjustment
    
    var path = Path()
    path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width/2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
    
    return path
  }
  
  func inset(by amount: CGFloat) -> some InsettableShape {
    var arc = self
    arc.insetAmount += amount
    return arc
  }
}

struct Flower: Shape {
  var petalOffset: Double = -20
  var petalWidth: Double = 100
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
      let rotation = CGAffineTransform(rotationAngle: number)
      let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
      let originalPetal = Path(ellipseIn: CGRect(x: petalOffset, y: 0, width: petalWidth, height: rect.width / 2))
      let rotatedPetal = originalPetal.applying(position)
      path.addPath(rotatedPetal)
    }
    
    return path
  }
}

struct ColorCyclingCircle: View {
  var amount = 0.0
  var steps = 100
  
  var body: some View {
    ZStack {
      ForEach(0..<steps) { value in
        Circle()
          .inset(by: Double(value))
          .strokeBorder(LinearGradient(gradient: Gradient(colors: [color(for: value, brightness: 1), color(for: value, brightness: 0.5)]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
          //          .strokeBorder(color(for: value, brightness: 1), lineWidth: 2)
      }
    }
    .drawingGroup()
  }
  
  func color(for value: Int, brightness: Double) -> Color {
    var targetHue = Double(value) / Double(steps) + amount
    
    if targetHue > 1 {
      targetHue -= 1
    }
    
    return Color(hue: targetHue, saturation: 1, brightness: brightness)
    
  }
  
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      //    ColorCyclingCircle()
  }
}
