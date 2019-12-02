//
//  ButtonsService.swift
//  Calculator
//
//  Created by Саша Руцман on 23/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation
import UIKit

final class ButtonsService
{
	var firstNumber = 0.0
	var secondNumber = 0.0
	var thirdNumber = 0.0
	var firstOperand = ""
	var divisionButtonTapped = false
	var divisionButtonTappedCount = 0
	var multipleButtonTapped = false
	var multipleButtonTappedCount = 0
	var plusButtonTapped = false
	var plusButtonTappedCount = 0
	var minusButtonTapped = false
	var minusButtonTappedCount = 0

	func numbersTapped(_ view: CalculatorView, _ sender: UIButton) {
		if view.calculatingLabel.text == "0" {
			view.calculatingLabel.text = String(sender.tag)
		}
		else {
			view.calculatingLabel.text = (view.calculatingLabel.text ?? "") + String(sender.tag)
		}
	}

	func ACTapped(_ view: CalculatorView) {
		view.calculatingLabel.text = "0"
		firstNumber = 0.0
		secondNumber = 0.0
		divisionButtonTappedCount = 0
		multipleButtonTappedCount = 0
		plusButtonTappedCount = 0
		minusButtonTappedCount = 0
		thirdNumber = 0.0
	}

	func oppositeSignTapped(_ view: CalculatorView) {
		if firstNumber != 0.0 {
			firstNumber *= -1
		}
		if (view.calculatingLabel.text ?? "").first != "-" {
			view.calculatingLabel.text = "-" + (view.calculatingLabel.text ?? "")
		}
		else if (view.calculatingLabel.text ?? "").first == "-" {
			view.calculatingLabel.text?.removeFirst()
		}
	}

	func percentTapped(_ view: CalculatorView) {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		if firstNumber == 0.0 {
			let doubleCalculatingLabelText = Double(view.calculatingLabel.text ?? "") ?? 0
			view.calculatingLabel.text = numberFormatter.string(from: doubleCalculatingLabelText / 100 as NSNumber) ?? ""
			firstNumber = Double(view.calculatingLabel.text ?? "0") ?? 0.0
		}
		else {
			let result = firstNumber / 100 * (Double(view.calculatingLabel.text ?? "") ?? 0)
			view.calculatingLabel.text = numberFormatter.string(from: result as NSNumber) ?? ""
			secondNumber = Double(view.calculatingLabel.text ?? "0") ?? 0.0
		}
	}

	func divisionTapped(_ view: CalculatorView) {
		divisionButtonTapped = true
		divisionButtonTappedCount += 1
		if divisionButtonTappedCount > 1 {
			firstNumber /= Double(view.calculatingLabel.text ?? "") ?? 0.0
		}
		else if firstNumber == 0.0 {
			firstNumber = Double(view.calculatingLabel.text ?? "") ?? 0.0
		}
		else if secondNumber == 0.0 {
			thirdNumber = Double(view.calculatingLabel.text ?? "") ?? 0.0
		}
		else if firstNumber != 0.0 && secondNumber != 0.0 {
			firstNumber /= secondNumber
			secondNumber = 0.0
		}
	}

	func multipleTapped(_ view: CalculatorView) {
		multipleButtonTapped = true
		multipleButtonTappedCount += 1
		if multipleButtonTappedCount > 1 {
			firstNumber *= Double(view.calculatingLabel.text ?? "") ?? 0.0
		}
		else if firstNumber == 0.0 {
			firstNumber = Double(view.calculatingLabel.text ?? "") ?? 0.0
		}
		else if secondNumber == 0.0 {
			thirdNumber = Double(view.calculatingLabel.text ?? "") ?? 0.0
		}
		else if firstNumber != 0 && secondNumber != 0 {
			firstNumber *= secondNumber
			secondNumber = 0.0
		}
	}

	func minusTapped(_ view: CalculatorView) {
		firstOperand = "-"
		minusButtonTapped = true
		minusButtonTappedCount += 1
		if minusButtonTappedCount > 1 {
			firstNumber -= Double(view.calculatingLabel.text ?? "") ?? 0.0
		}
		else if firstNumber == 0.0 {
			firstNumber = Double(view.calculatingLabel.text ?? "") ?? 0.0
		}
		else if firstNumber != 0 && secondNumber != 0 {
			firstNumber -= secondNumber
			secondNumber = 0.0
		}
	}

	func plusTapped(_ view: CalculatorView) {
		firstOperand = "+"
		plusButtonTapped = true
		plusButtonTappedCount += 1
		if plusButtonTappedCount > 1 {
			firstNumber += Double(view.calculatingLabel.text ?? "") ?? 0.0
		}
		else if firstNumber == 0.0 {
			firstNumber = Double(view.calculatingLabel.text ?? "") ?? 0.0
		}
		else if firstNumber != 0 && secondNumber != 0 {
			firstNumber += secondNumber
			secondNumber = 0.0
		}
	}

	func calculate(_ operand: String, _ view: CalculatorView, _ firstNumber: Double, _ secondNumber: Double) {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		switch operand {
		case "/":
			let result = firstNumber / secondNumber
			view.calculatingLabel.text = numberFormatter.string(from: result as NSNumber) ?? ""
		case "*":
			let result = firstNumber * secondNumber
			view.calculatingLabel.text = numberFormatter.string(from: result as NSNumber) ?? ""
		case "-":
			let result = firstNumber - secondNumber
			view.calculatingLabel.text = numberFormatter.string(from: result as NSNumber) ?? ""
		case "+":
			let result = firstNumber + secondNumber
			view.calculatingLabel.text = numberFormatter.string(from: result as NSNumber) ?? ""
		default:
			break
		}
		if self.thirdNumber != 0.0 {
			self.thirdNumber = 0.0
			self.secondNumber = Double(view.calculatingLabel.text ?? "") ?? 0.0
		}
		else {
			self.firstNumber = Double(view.calculatingLabel.text ?? "") ?? 0.0
			self.secondNumber = 0.0
		}
	}

	func equallyTapped(_ view: CalculatorView, _ operand: String) {
		divisionButtonTappedCount = 0
		multipleButtonTappedCount = 0
		plusButtonTappedCount = 0
		minusButtonTappedCount = 0
		if firstNumber != 0.0 && secondNumber != 0.0 && thirdNumber == 0.0 {
			calculate(operand, view, firstNumber, secondNumber)
		}
		else if secondNumber == 0.0 && thirdNumber == 0.0 {
			secondNumber = Double(view.calculatingLabel.text ?? "") ?? 0.0
			calculate(operand, view, firstNumber, secondNumber)
		}
		else if thirdNumber != 0.0 {
			secondNumber = Double(view.calculatingLabel.text ?? "") ?? 0.0
			calculate(operand, view, thirdNumber, secondNumber)
			equallyTapped(view, firstOperand)
		}
	}

	func updateACButtonTitle(_ view: CalculatorView) {
		view.calculatingLabel.text == "0" ?
			view.ACButton.setTitle("AC", for: .normal) :
			view.ACButton.setTitle("C", for: .normal)
	}
}
