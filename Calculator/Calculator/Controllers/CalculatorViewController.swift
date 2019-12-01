//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Artem Orlov on 12/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorViewController: UIViewController
{
	private let calculatorView = CalculatorView()

	private var calculatorEngine = CalculatorEngine()
	private var clearLabel = false

	override func loadView() {
		self.view = calculatorView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		calculatorView.delegate = self
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}

extension CalculatorViewController: ICalculatorViewDelegate
{
	func clickedButton(_ text: String) {
		print(text)
		switch text {
		case "AC": self.allClear()
		case "C": self.clear()
		case "⁺⁄₋": self.plusMinusSign()
		case "%": self.percent()
		case "÷": self.divideAction()
		case "×": self.multiplyAction()
		case "−": self.subtractAction()
		case "+": self.addAction()
		case "=": self.equal()
		case ",": self.comma()
		case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9": self.digit(inputText: text)
		default: assertionFailure("clickedButton() обрабатывает несуществующий кейс.")
		}
	}
}

extension CalculatorViewController: ICalculatorButtonsActions
{
	func allClear() {
		self.calculatorEngine.allClearCalculation()
		calculatorView.resultLabel.text = "0"
		self.clearLabel = false
		print("allClear")
	}

	func clear() {
		calculatorView.resultLabel.text = "0"
		calculatorView.buttonsLabels[0].text = "AC"
		self.clearLabel = false
		self.calculatorEngine.clearCalculation()
	}

	func plusMinusSign() {
		print("plusMinusSign")
		//		if clearLabel {
		//			calculatorView.resultLabel.text = "0"
		//			self.clearLabel = false
		//			self.calculatorEngine.isNewValue = true
		//		}
		guard let resultLabelStartIndex = calculatorView.resultLabel.text?.startIndex else { return }
		if calculatorView.resultLabel.text?.first != "-" {
			calculatorView.resultLabel.text?.insert("-", at: resultLabelStartIndex)
		}
		else {
			calculatorView.resultLabel.text?.removeFirst()
		}
	}

	func percent() {
		//		guard let text = calculatorView.resultLabel.text,
		//		let value = Double(text.replacingOccurrences(of: ",", with: "."))else { return }
		//		if polandItems.count == 2, let firstItem = polandItems.first {
		//			switch firstItem {
		//			case .number(let number):
		//				let resultValue = number * value / 100
		//				let result = String(resultValue).replacingOccurrences(of: ".", with: ",")
		//				calculatorView?.resultLabel.text = result.format()
		//			default:
		//				return
		//			}
		//		}
		//		else {
		//			let resultValue = value / 100
		//			polandItems.append(.number(resultValue))
		//			let result = String(resultValue).replacingOccurrences(of: ".", with: ",")
		//			calculatorView.resultLabel.text = result
		//		}
	}

	func addAction() {
		if let result = self.calculatorEngine.addAction(input: calculatorView.resultLabel.text) {
			self.calculatorView.resultLabel.text = result
		}
		self.clearLabel = true
	}

	func subtractAction() {
		if let result = self.calculatorEngine.subtractAction(input: calculatorView.resultLabel.text) {
			self.calculatorView.resultLabel.text = result
		}
		self.clearLabel = true
	}

	func multiplyAction() {
		if let result = self.calculatorEngine.multiplyAction(input: calculatorView.resultLabel.text) {
			self.calculatorView.resultLabel.text = result
		}
		self.clearLabel = true
	}

	func divideAction() {
		if let result = self.calculatorEngine.divideAction(input: calculatorView.resultLabel.text) {
			self.calculatorView.resultLabel.text = result
		}
		self.clearLabel = true
	}

	func equal() {
		if let result = self.calculatorEngine.resultAction(input: calculatorView.resultLabel.text) {
			self.calculatorView.resultLabel.text = result
		}
		self.clearLabel = true
	}

	func comma() {
		guard let text = calculatorView.resultLabel.text else { return }
		guard text.contains(",") == false else { return }
		let containMinus = (text.first == "-")
		if containMinus && text.count < 10 {
			calculatorView.resultLabel.text?.append(",")
		}
		else if containMinus == false && text.count < 9 {
			calculatorView.resultLabel.text?.append(",")
		}
	}

	func digit(inputText: String) {
		if calculatorView.resultLabel.text == "0" {
			calculatorView.resultLabel.text = "\(inputText)"
			calculatorView.buttonsLabels[0].text = "C"
			self.calculatorEngine.isNewValue = true
		}
		else if calculatorView.resultLabel.text == "-0" {
			calculatorView.resultLabel.text = "-\(inputText)"
			calculatorView.buttonsLabels[0].text = "C"
			self.calculatorEngine.isNewValue = true
		}
		else {
			if clearLabel {
				calculatorView.resultLabel.text = ""
				self.clearLabel = false
				self.calculatorEngine.isNewValue = true
			}
			guard let text = calculatorView.resultLabel.text else { return }
			let containMinus = (text.first == "-")
			let containComma = text.contains(",")

			if containMinus && containComma && text.count < 11 {
				calculatorView.resultLabel.text?.append(inputText)
			}
			else if containMinus == false && containComma && text.count < 10 {
				calculatorView.resultLabel.text?.append(inputText)
			}
			else if containMinus && containComma == false && text.count < 10 {
				calculatorView.resultLabel.text?.append(inputText)
			}
			else if text.count < 9 {
				calculatorView.resultLabel.text?.append(inputText)
			}
		}
	}
}
