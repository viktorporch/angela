//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by Victor on 11.11.2023.
//

import UIKit

struct CalculatorBrain {
    private(set) var bmi: BMI?
    
    func getColor() -> UIColor {
        bmi?.color ?? .white
    }
    
    func getAdvice() -> String {
        bmi?.advice ?? "No advice"
    }
    
    func getValue() -> Double {
        round(bmi?.value ?? 0.0 * 100.0)
    }
    
    mutating func calculateBMI(weight: Float, height: Float) {
        let bmiValue = Double(weight / (height * height))
        
        if bmiValue < 18.5 {
            bmi = BMI(value: bmiValue, advice: "Eat more pies!", color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
        } else if bmiValue < 24.9 {
            bmi = BMI(value: bmiValue, advice: "Fit as a fiddle!", color: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
        } else {
            bmi = BMI(value: bmiValue, advice: "Eat less pies!", color: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
        }
    }
}
