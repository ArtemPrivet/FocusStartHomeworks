//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Artem Orlov on 12/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit
import SnapKit

final class CalculatorViewController: UIViewController
{

	var buttons = [CalculatorButtons]()
	var resultLabel = UILabel()

	var resultNumber = 0
	var firstOperand = 0.0
	var secondOperand = 0.0
	var operatorSign = ""
	var isPressedAcButton = false
	var isTyping = false
	var isFloatNumber = false

	var currentInput: Double {
		get {
			return Double(resultLabel.text ?? "") ?? 0
		}
		set {
			if String(newValue).hasSuffix(".0") {
				resultLabel.text = String(String(newValue).dropLast(2))
			}
			else {
				resultLabel.text = String(newValue)
			}
			isTyping = false
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .black
		addButtonActions()
		setGestureRecognizer()
	}

	override func loadView() {
		let calcView = CalcalatorView()
		self.view = calcView
		resultLabel = calcView.resultLabel
		buttons = calcView.buttons.sorted(by: { button1, button2 -> Bool in
			button1.tag < button2.tag
		})
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupSubViews()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	func setupSubViews() {
		buttons.forEach { button in
			if button.tag == 0 {
				button.contentHorizontalAlignment = .left
				button.contentEdgeInsets = UIEdgeInsets(top: 0, left: button.frame.height / 2 - 7, bottom: 0, right: 0)
			}
			button.layer.cornerRadius = button.bounds.height / 2
		}
	}

	func setGestureRecognizer() {
		let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(deleteSymbolFromLabel))
		swipeGestureRecognizer.direction = [.left, .right]
		resultLabel.addGestureRecognizer(swipeGestureRecognizer)
		resultLabel.isUserInteractionEnabled = true
	}

	@objc func deleteSymbolFromLabel() {
		guard isTyping, let labelText = resultLabel.text else { return }
		let newText = String(labelText.dropLast())
		if newText.count > 0 {
			resultLabel.text = newText
		}
		else {
			resultLabel.text = "0"
			isTyping = false
		}
	}

	func addButtonActions() {
		buttons.forEach { button in
			switch button.tag {
			case 0...9:
				button.addTarget(self, action: #selector(numberButtonPressed), for: .touchUpInside)
			case 10:
				button.addTarget(self, action: #selector(floatButtonPressed), for: .touchUpInside)
			case 11:
				button.addTarget(self, action: #selector(equalButtonPressed), for: .touchUpInside)
			case 12...15:
				button.addTarget(self, action: #selector(operatorButtonPressed), for: .touchUpInside)
			case 16:
				button.addTarget(self, action: #selector(percentButtonPressed), for: .touchUpInside)
			case 17:
				button.addTarget(self, action: #selector(negativeSwitchButtonPressed), for: .touchUpInside)
			case 18:
				button.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
			default: break
			}
		}
	}

	// MARK: - Button functions
	@objc func floatButtonPressed(_ sender: CalculatorButtons) {
		if isTyping && isFloatNumber == false {
			resultLabel.text = (resultLabel.text ?? "") + "."
			isFloatNumber = true
		}
		else if isTyping && isFloatNumber == false {
			resultLabel.text = "0."
		}
	}

	@objc func percentButtonPressed(_ sender: CalculatorButtons) {
		if firstOperand == 0 {
			currentInput /= 100
		}
		else {
			currentInput = firstOperand * currentInput / 100
			secondOperand = currentInput
		}
	}

	@objc func negativeSwitchButtonPressed(_ sender: CalculatorButtons) {
		currentInput *= -1
	}

	@objc func clearButtonPressed(_ sender: CalculatorButtons) {
		firstOperand = 0
		secondOperand = 0
		currentInput = 0
		resultLabel.text = "0"
		isTyping = false
		operatorSign = ""
		isFloatNumber = false
	}

	@objc func numberButtonPressed(_ sender: CalculatorButtons) {
		if isTyping {
			resultLabel.text = (resultLabel.text ?? "") + String(sender.tag)
		}
		else {
			resultLabel.text = String(sender.tag)
			isTyping = true
		}
	}

	@objc func equalButtonPressed(_ sender: CalculatorButtons) {
		if isTyping { //если на экране, что то есть
			secondOperand = currentInput
		}

		switch operatorSign {
		case "+": makeOperation { $0 + $1 }
		case "-": makeOperation { $0 - $1 }
		case "*": makeOperation { $0 * $1 }
		case "/": makeOperation { $0 / $1 }
		default: break
		}
		isFloatNumber = false
	}
	@objc func operatorButtonPressed(_ sender: CalculatorButtons) {
		equalButtonPressed(sender) //check for bug
		switch sender.tag {
		case OperationButtons.plus: operatorSign = "+"
		case OperationButtons.minus: operatorSign = "-"
		case OperationButtons.multiply: operatorSign = "*"
		case OperationButtons.divide: operatorSign = "/"
		default: break
		}
		firstOperand = currentInput
		isTyping = false
		isFloatNumber = false
	}

	func makeOperation(_ operation: (Double, Double) -> Double) {
		currentInput = operation(firstOperand, secondOperand)
		isTyping = false
	}
}
