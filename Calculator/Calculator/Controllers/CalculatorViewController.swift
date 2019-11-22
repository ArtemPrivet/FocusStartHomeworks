//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Artem Orlov on 12/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorViewController: UIViewController, CalculatorViewDelegate
{
	var calculatorView: CalculatorView? {
		return self.view as? CalculatorView
	}

	var polandItems: [Item] = []
	let polishNotation = PolishNotation()
	var clearLabel = false

	override func loadView() {
		self.view = CalculatorView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		calculatorView?.delegate = self
	}

	func clickedButton(_ text: String) {
		print(text)
		switch text {
		case "AC": self.allClear()
		case "C": self.clear()
		case "⁺⁄₋": self.plusMinusSign()
		case "%": self.percent()
		case "÷": self.divideAction()
		case "×": self.multiplyAction()
		case "-": self.subtractAction()
		case "+": self.addAction()
		case "=": self.equal()
		case ",": self.comma()
		case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9": self.digit(inputText: text)
		default: assertionFailure("clickedButton() обрабатывает несуществующий кейс.")
		}
	}

	func allClear() {
		self.polandItems.removeAll()
		calculatorView?.resultLabel.text = "0"
		self.clearLabel = false
		print("allClear")
	}

	func clear() {
		calculatorView?.resultLabel.text = "0"
		calculatorView?.buttonsLabels[0].text = "AC"
		self.clearLabel = false
	}

	func plusMinusSign() {
		print("plusMinusSign")
		if clearLabel {
			calculatorView?.resultLabel.text = "0"
			self.clearLabel = false
		}
		guard let resultLabel = calculatorView?.resultLabel,
			let resultLabelStartIndex = resultLabel.text?.startIndex else { return }
		if resultLabel.text?.first != "-" {
			resultLabel.text?.insert("-", at: resultLabelStartIndex)
		}
		else {
			resultLabel.text?.removeFirst()
		}
	}

	func percent() {
		guard let text = calculatorView?.resultLabel.text,
		let value = Double(text.replacingOccurrences(of: ",", with: "."))else { return }
		if polandItems.count == 2, let firstItem = polandItems.first {
			switch firstItem {
			case .number(let number):
				let resultValue = number * value / 100
				let result = String(resultValue).replacingOccurrences(of: ".", with: ",")
				calculatorView?.resultLabel.text = result.format()
			default:
				return
			}
		}
		else {
			let resultValue = value / 100
			polandItems.append(.number(resultValue))
			let result = String(resultValue).replacingOccurrences(of: ".", with: ",")
			calculatorView?.resultLabel.text = result
		}
	}

	func calculateResultAndSetInLabel() {
		guard let resultLabelText = calculatorView?.resultLabel.text,
			let value = Double(resultLabelText.replacingOccurrences(of: ",", with: ".")) else { return }
		polandItems.append(.number(value))
		if polandItems.count >= 3 {
			guard let polishNotationResult = polishNotation.makeCalculation(self.polandItems) else { return }
			polandItems.removeAll()
			polandItems.append(.number(polishNotationResult))
			let stringResult = String(polishNotationResult).replacingOccurrences(of: ".", with: ",").format()
			if polishNotationResult.truncatingRemainder(dividingBy: 1) == 0 {
				let intResult = Int(polishNotationResult)
				calculatorView?.resultLabel.text = String(intResult).replacingOccurrences(of: ".", with: ",").format()
			}
			else {
				calculatorView?.resultLabel.text = stringResult
			}
		}
		self.clearLabel = true
	}

	// Переделать условия выполнения во всех операторах (Высчитывание в момент встречи разных приоритетов)
	func addAction() {
		calculateResultAndSetInLabel()
		polandItems.append(.sign(.plus))
	}

	func subtractAction() {
		calculateResultAndSetInLabel()
		polandItems.append(.sign(.minus))
	}

	func multiplyAction() {
		calculateResultAndSetInLabel()
		polandItems.append(.sign(.multiply))
	}

	func divideAction() {
		calculateResultAndSetInLabel()
		polandItems.append(.sign(.divide))
	}

	func equal() {
		calculateResultAndSetInLabel()
	}

	func comma() {
		guard let text = calculatorView?.resultLabel.text else { return }
		guard text.contains(",") == false else { return }
		let containMinus = (text.first == "-")
		if containMinus && text.count < 10 {
			calculatorView?.resultLabel.text?.append(",")
		}
		else if containMinus == false && text.count < 9 {
			calculatorView?.resultLabel.text?.append(",")
		}
	}

	func digit(inputText: String) {
		guard let resultLabel = calculatorView?.resultLabel else { return }
		if resultLabel.text == "0" {
			resultLabel.text = "\(inputText)"
			calculatorView?.buttonsLabels[0].text = "C"
		}
		else if resultLabel.text == "-0" {
			resultLabel.text = "-\(inputText)"
			calculatorView?.buttonsLabels[0].text = "C"
		}
		else {
			if clearLabel {
				resultLabel.text = ""
				self.clearLabel = false
			}
			guard let text = resultLabel.text else { return }
			let containMinus = (text.first == "-")
			let containComma = text.contains(",")

			if containMinus && containComma && text.count < 11 {
				calculatorView?.resultLabel.text?.append(inputText)
			}
			else if containMinus == false && containComma && text.count < 10 {
				calculatorView?.resultLabel.text?.append(inputText)
			}
			else if containMinus && containComma == false && text.count < 10 {
				calculatorView?.resultLabel.text?.append(inputText)
			}
			else if text.count < 9 {
				calculatorView?.resultLabel.text?.append(inputText)
			}
		}
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}
