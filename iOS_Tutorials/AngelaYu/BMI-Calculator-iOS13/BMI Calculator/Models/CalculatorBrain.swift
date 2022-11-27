
import UIKit

struct CalculatorBrain {
    var bmi: BMI?
    
    func getBMIValue() -> String {
        let bmiAsString = String(format: "%.1f", bmi?.value ?? 0.0)
        return bmiAsString
    }
    
    func getAdvice() -> String {
        return bmi?.advice ?? "Error"
    }
    
    func getColor() -> UIColor {
        return bmi?.color ?? UIColor.yellow
    }
    
    mutating func calculateBMI(height: Float, weight: Float) {
        let bmiValue = weight / (height*height)
        
        if bmiValue < 18.5 {
            bmi = BMI(value: bmiValue, advice: "Eat more pies.", color: UIColor.blue)
        }
        else if bmiValue < 24.9 {
            bmi = BMI(value: bmiValue, advice: "Fit as a fiddle.", color: UIColor(red: 0/255, green: 165/255, blue: 104/255, alpha: 1.0))
        }
        else {
            bmi = BMI(value: bmiValue, advice: "Eat fewer pies.", color: UIColor.red)
        }
    }
    
    
}
