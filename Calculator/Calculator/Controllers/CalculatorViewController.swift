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
	private var logicOperation = LogicOperation()
	private var calculatorScreen = CalculatorScreen()
	private var buttons = [UIButton]()
	private var resultLabel = UILabel()
	private var typingBegan = false
	let formatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.groupingSize = 3
		formatter.maximumIntegerDigits = 9
		formatter.maximumFractionDigits = 9
		formatter.notANumberSymbol = "Ошибка"
		formatter.usesGroupingSeparator = true
		formatter.groupingSeparator = " "
		formatter.locale = Locale.current
		return formatter
	}()
	var displayValue: Double? {
		get {
			getValue(resultLabel.text)
		}
		set {
			resultLabel.text = setValue(newValue)
			typingBegan = false
			changeACButton()
		}
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		accessToElements()
		addTarget()
		swipe()
	}

	override func loadView() {
		self.view = calculatorScreen
	}
	func accessToElements() {
		buttons = calculatorScreen.buttonsView.buttons
		resultLabel = calculatorScreen.resultLabel
	}
	@objc func pressNumber(_ sender: UIButton) {
		if let digit = sender.currentTitle{
			if typingBegan {
				if let textCurrentlyInDisplay = resultLabel.text {
					if digit != "," || textCurrentlyInDisplay.contains(",") == false {
						resultLabel.text = textCurrentlyInDisplay + digit
					}
				}
			}
			else {
				resultLabel.text = digit
				typingBegan = true
			}
		}
		changeACButton()
	}
	@objc func pressOperator(_ sender: UIButton) {
		if typingBegan {
			if let value = displayValue {
				logicOperation.setDigit(value)
			}
			typingBegan = false
		}
		if let mathematicsSymbol = sender.currentTitle {
			logicOperation.performOperation(mathematicsSymbol)
		}
		if let result = logicOperation.result {
			displayValue = result
		}
		changeACButton()
	}
	@objc func pressAC(_ sender: UIButton) {
		if sender.currentTitle == "C" {
			logicOperation.null()
			displayValue = 0
			typingBegan = false
			changeACButton()
		}
	}
	@objc func swipToDeleteNumber(_ sender: UISwipeGestureRecognizer) {
		if typingBegan, var typingText = resultLabel.text {
			if typingText.count > 0 {
				typingText.removeLast()
				guard typingText.isEmpty == false else { return resultLabel.text = "0" }
				resultLabel.text = typingText
			}
			else {
				resultLabel.text = "0"
				typingBegan = false
			}
		}
	}
	func swipe() {
		let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipToDeleteNumber(_:)))
		let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipToDeleteNumber(_:)))
		leftSwipe.direction = .left
		rightSwipe.direction = .right
		self.view.addGestureRecognizer(leftSwipe)
		self.view.addGestureRecognizer(rightSwipe)
	}
	func addTarget() {
		for button in buttons {
			if let text = button.currentTitle {
				if Int(text) != nil || text == "," {
					button.addTarget(self, action: #selector(self.pressNumber(_:)), for: .touchUpInside)
				}
				else if text == "AC" {
					button.addTarget(self, action: #selector(self.pressAC(_:)), for: .touchUpInside)
				}
				else {
					button.addTarget(self, action: #selector(self.pressOperator(_:)), for: .touchUpInside)
				}
			}
		}
	}
	func changeACButton() {
		let text = resultLabel.text
		for button in buttons {
			if button.currentTitle == "AC", text != "0" {
				button.setTitle("C", for: .normal)
			}
			else if button.currentTitle == "C", text == "0" {
				button.setTitle("AC", for: .normal)
			}
		}
	}
	func setValue(_ newValue: Double?) -> String {
		var text = ""
		if let value = newValue {
			guard value.isInfinite == false else { return "Ошибка" }
			if String(value).count > 12 {
				formatter.numberStyle = .scientific
				formatter.exponentSymbol = "e"
			}
			else {
				formatter.numberStyle = .decimal
			}
			let textValue = formatter.string(from: NSNumber(value: value)) ?? "0"
			text = textValue.replacingOccurrences(of: ".", with: ",")
		}
		else {
			text = "0"
		}
		return text
	}
	func getValue(_ textValue: String?) -> Double {
		if let text = textValue?.replacingOccurrences(of: ",", with: ".") {
			return formatter.number(from: text)?.doubleValue ?? 0
		}
		else {
			return 0
		}
	}
}
