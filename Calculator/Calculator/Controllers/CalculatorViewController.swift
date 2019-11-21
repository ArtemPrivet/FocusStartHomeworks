//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Artem Orlov on 12/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorViewController: UIViewController, CalculatorActionsProtocol
{

	let calculatorView = CalculatorView()
	var polandItems: [PolandItem] = []
	var clearLabel = false

	override func loadView() {
		self.view = calculatorView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.getView()?.delegate = self
	}

	func getView() -> CalculatorView? {
		return self.view as? CalculatorView
	}

	func allClear() {
		self.polandItems.removeAll()
		self.getView()?.resultLabel.text = "0"
		self.clearLabel = false
		print("allClear")
	}

	func clear() {
		self.getView()?.resultLabel.text = "0"
		self.getView()?.buttonsLabels[0].text = "AC"
		self.clearLabel = false
	}

	func plusMinusSign() {
		print("plusMinusSign")
		if clearLabel {
			self.getView()?.resultLabel.text = "0"
			self.clearLabel = false
		}
		guard let resultLabel = self.getView()?.resultLabel,
			let resultLabelStartIndex = resultLabel.text?.startIndex else { return }
		if resultLabel.text?.first != "-" {
			resultLabel.text?.insert("-", at: resultLabelStartIndex)
		}
		else {
			resultLabel.text?.removeFirst()
		}
	}

	func percent() {
		guard let text = self.getView()?.resultLabel.text,
		let value = Double(text.replacingOccurrences(of: ",", with: "."))else { return }
		if polandItems.count < 3, let firstItem = polandItems.first {
			switch firstItem {
			case .number(let number):
				let resultValue = number * value / 100
				let result = String(resultValue).replacingOccurrences(of: ".", with: ",")
				self.getView()?.resultLabel.text = result.format()
			default:
				return
			}
		}
		else {
			let resultValue = value / 100
			polandItems.append(.number(resultValue))
			let result = String(resultValue).replacingOccurrences(of: ".", with: ",")
			self.getView()?.resultLabel.text = result
		}
	}

	// Переделать условия выполнения во всех операторах (Высчитвание в момент встречи разных приоритетов)
	func addAction() {
		guard let resultLabelText = self.getView()?.resultLabel.text,
			let value = Double(resultLabelText.replacingOccurrences(of: ",", with: ".")) else { return }
		polandItems.append(.number(value))
		if polandItems.count >= 3 {
			let polandScriptArray = polandScript(input: self.polandItems)
			let polandScriptStringArray = polandScriptToStringArray(input: polandScriptArray)
			guard let polandScriptResult = polandScriptGetResult(input: polandScriptStringArray) else { return }
			polandItems.removeAll()
			polandItems.append(.number(polandScriptResult))
			self.getView()?.resultLabel.text = String(polandScriptResult).replacingOccurrences(of: ".", with: ",").format()
		}
		polandItems.append(.sign(.plus))
		self.clearLabel = true
	}

	func subtractAction() {
		guard let resultLabelText = self.getView()?.resultLabel.text,
			let value = Double(resultLabelText.replacingOccurrences(of: ",", with: ".")) else { return }
		polandItems.append(.number(value))
		if polandItems.count >= 3 {
			let polandScriptArray = polandScript(input: self.polandItems)
			let polandScriptStringArray = polandScriptToStringArray(input: polandScriptArray)
			guard let polandScriptResult = polandScriptGetResult(input: polandScriptStringArray) else { return }

			polandItems.removeAll()
			polandItems.append(.number(polandScriptResult))
			self.getView()?.resultLabel.text = String(polandScriptResult).replacingOccurrences(of: ".", with: ",").format()
		}
		polandItems.append(.sign(.minus))
		self.clearLabel = true
	}

	func multiplyAction() {
		guard let resultLabelText = self.getView()?.resultLabel.text,
			let value = Double(resultLabelText.replacingOccurrences(of: ",", with: ".")) else { return }
		polandItems.append(.number(value))
		if polandItems.count >= 3 {
			let polandScriptArray = polandScript(input: self.polandItems)
			let polandScriptStringArray = polandScriptToStringArray(input: polandScriptArray)
			guard let polandScriptResult = polandScriptGetResult(input: polandScriptStringArray) else { return }

			polandItems.removeAll()
			polandItems.append(.number(polandScriptResult))
			self.getView()?.resultLabel.text = String(polandScriptResult).replacingOccurrences(of: ".", with: ",").format()
		}
		polandItems.append(.sign(.multiply))
		self.clearLabel = true
	}

	func divideAction() {
		guard let resultLabelText = self.getView()?.resultLabel.text,
			let value = Double(resultLabelText.replacingOccurrences(of: ",", with: ".")) else { return }
		polandItems.append(.number(value))
		if polandItems.count >= 3 {
			let polandScriptArray = polandScript(input: self.polandItems)
			let polandScriptStringArray = polandScriptToStringArray(input: polandScriptArray)
			guard let polandScriptResult = polandScriptGetResult(input: polandScriptStringArray) else { return }

			polandItems.removeAll()
			polandItems.append(.number(polandScriptResult))
			self.getView()?.resultLabel.text = String(polandScriptResult).replacingOccurrences(of: ".", with: ",").format()
		}
		polandItems.append(.sign(.divide))
		self.clearLabel = true
	}

	func equal() {
		print("equal")
		guard let resultLabelText = self.getView()?.resultLabel.text,
			let value = Double(resultLabelText.replacingOccurrences(of: ",", with: ".")) else { return }

		self.polandItems.append(.number(value))
		let polandScriptArray = polandScript(input: self.polandItems)
		let polandScriptStringArray = polandScriptToStringArray(input: polandScriptArray)
		guard let polandScriptResult = polandScriptGetResult(input: polandScriptStringArray) else { return }
		polandItems.removeAll()
		polandItems.append(.number(polandScriptResult))
		self.getView()?.resultLabel.text = String(polandScriptResult).replacingOccurrences(of: ".", with: ",").format()
		self.clearLabel = true
	}

	func comma() {
		guard let text = self.getView()?.resultLabel.text else { return }
		guard text.contains(",") == false else { return }
		let containMinus = (text.first == "-")
		if containMinus && text.count < 10 {
			self.getView()?.resultLabel.text?.append(",")
		}
		else if containMinus == false && text.count < 9 {
			self.getView()?.resultLabel.text?.append(",")
		}
	}

	func digit(inputText: String) {
		guard let resultLabel = self.getView()?.resultLabel else { return }
		if resultLabel.text == "0" {
			resultLabel.text = "\(inputText)"
			self.getView()?.buttonsLabels[0].text = "C"
		}
		else if resultLabel.text == "-0" {
			resultLabel.text = "-\(inputText)"
			self.getView()?.buttonsLabels[0].text = "C"
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
				self.getView()?.resultLabel.text?.append(inputText)
			}
			else if containMinus == false && containComma && text.count < 10 {
				self.getView()?.resultLabel.text?.append(inputText)
			}
			else if containMinus && containComma == false && text.count < 10 {
				self.getView()?.resultLabel.text?.append(inputText)
			}
			else if text.count < 9 {
				self.getView()?.resultLabel.text?.append(inputText)
			}
		}
		print(self.polandItems)
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}
