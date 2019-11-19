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
	private var brain = LogicOperation()
	var calculatorScreen = CalculatorScreen()
	var buttons = [UIButton]()
	var resultLabel = UILabel()
	var userIsInTheMiddleOfTyping = false
	var displayValue: Double {
		get {
			return Double(resultLabel.text ?? "0") ?? 0
		}
		set {
			resultLabel.text = String(newValue)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		accessToElements()
		for button in buttons {
			button.layer.cornerRadius = button.bounds.height / 2
			if let text = button.titleLabel?.text {
				guard Int(text) != nil else { return }
				button.addTarget(self, action: #selector(CalculatorViewController.touchDigit(_:)), for: .touchUpInside)
			}
		}
	}

	override func loadView() {
		self.view = calculatorScreen
	}

	func accessToElements() {
		buttons = calculatorScreen.buttonsView.buttons
		resultLabel = calculatorScreen.resultLabel
	}
	@objc func touchDigit(_ sender: UIButton) {
		if let digit = sender.currentTitle {
			if userIsInTheMiddleOfTyping {
				if let textCurrentlyInDisplay = resultLabel.text {
					resultLabel.text = textCurrentlyInDisplay + digit
				}
				else {
					resultLabel.text = digit
					userIsInTheMiddleOfTyping = true
				}
			}
		}
	}
	func performOperation(_ sender: UIButton) {
		if userIsInTheMiddleOfTyping {
			brain.setOperand(displayValue)
			userIsInTheMiddleOfTyping = false
		}
		if let mathematicsSymbol = sender.currentTitle {
			brain.performOperation(mathematicsSymbol)
		}
		if let result = brain.result {
			displayValue = result
		}
	}

	
}
