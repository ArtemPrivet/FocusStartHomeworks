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
	// MARK: - PROPERTIES
	private let calculatorView = CalculatorView()
	private let zero = "0"
	private var calc = Calculator()

	// MARK: - VC LIFE CYCLE METHODS
	override func loadView() {
		view = calculatorView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureButtons()
		addSwipeToLabel()
	}

	// MARK: - BUTTONS HANDLING
	private func configureButtons() {
		for button in calculatorView.buttonsStack.cells {
			button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
		}
	}

	private func toggleClearButtonTitle() {
		// AC <-> C
		calculatorView.buttonsStack.cells.first?.setTitle(
			calculatorView.screenLabel.text != zero ? Operation.clear.rawValue : Operation.allClear.rawValue,
			for: .normal
		)
	}

	@objc private func buttonTapped(_ sender: Button) {
		//Добавить обработку нажатия кнопок
		sender.blink()
		updateLabel(with: sender.currentTitle)
//		sender.isSelected = true
//		if sender.isSelected {
//			sender.reverseColors()
//		}
		toggleClearButtonTitle()
	}

	// MARK: - LABEL HANDLING
	private func updateLabel(with userInput: String?) {
		guard let symbol = userInput else { return }
		//if it's number or comma
		if Double(symbol) != nil || symbol == Operation.comma.rawValue  {
			if calculatorView.screenLabel.text == zero {
				calculatorView.screenLabel.text = (symbol == Operation.comma.rawValue) ? zero : ""
			}
			calculatorView.screenLabel.text? += symbol
		}
		else {
			// it's some operator
			switch symbol {
			case Operation.clear.rawValue: clear()
			default:
				break
			}
		}
		cutLabelLength()
	}

	// Обрезать строку если в ней свыше 10 символов
	private func cutLabelLength() {
		guard let count = calculatorView.screenLabel.text?.count else { return }

		if count > 9 {
			calculatorView.screenLabel.text = calculatorView.screenLabel.text?.maxLength(length: 10)
		}
	}

	private func clear() {
		if calculatorView.screenLabel.text != zero {
			calculatorView.screenLabel.text = zero
		}
	}

	private func addSwipeToLabel() {
		let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeOnLabel))
		swipeRecognizer.direction = [.left, .right]
		calculatorView.screenLabel.isUserInteractionEnabled = true
		calculatorView.screenLabel.addGestureRecognizer(swipeRecognizer)
	}

	@objc private func swipeOnLabel() {
		if calculatorView.screenLabel.text?.isEmpty == false {
			if calculatorView.screenLabel.text != zero {
				calculatorView.screenLabel.text?.removeLast()
				if calculatorView.screenLabel.text?.first == nil {
					calculatorView.screenLabel.text = zero
				}
			}
			else {
				calculatorView.screenLabel.text = zero
			}
		}
	}
}
