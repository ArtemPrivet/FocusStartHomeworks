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
	private let zero = "0"
	private var calc = Calculator()

	// MARK: - VC LIFE CYCLE METHODS
	override func loadView() {
		view = BackgroundView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureButtons()
		addSwipeToLabel()
	}

	// MARK: - BUTTONS HANDLING
	private func configureButtons() {
		guard let view = view as? BackgroundView else { return }
		for button in view.buttonsStack.cells {
			button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
		}
	}

	private func toggleClearButtonTitle() {
		// AC <-> C
		guard let view = view as? BackgroundView else { return }
		view.buttonsStack.cells.first?.setTitle(
			view.screenLabel.text != "0" ? "C" : "AC",
			for: .normal
		)
	}

	@objc private func buttonTapped(_ sender: Button) {
		//Добавить обработку нажатия кнопок
		guard let view = view as? BackgroundView else { return }
		sender.blink()
		updateLabel(with: sender.currentTitle)
		toggleClearButtonTitle()
	}
	// MARK: - LABEL HANDLING
	private func updateLabel(with userInput: String?) {
		guard let symbol = userInput else { return }
		guard let view = view as? BackgroundView else { return }
		if Double(symbol) != nil || symbol == Operation.comma.rawValue  {
			if view.screenLabel.text == zero {
				view.screenLabel.text = (symbol == Operation.comma.rawValue) ? zero : ""
			}
			view.screenLabel.text? += symbol
		}
		cutLabelLength()
	}

	private func cutLabelLength() {
		guard let view = view as? BackgroundView else { return }
		guard let count = view.screenLabel.text?.count else { return }

		if count > 9 {
			view.screenLabel.text = view.screenLabel.text?.maxLength(length: 10)
		}
	}

	private func addSwipeToLabel() {
		guard let view = view as? BackgroundView else { return }
		let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeOnLabel))
		swipeRecognizer.direction = [.left, .right]
		view.screenLabel.isUserInteractionEnabled = true
		view.screenLabel.addGestureRecognizer(swipeRecognizer)
	}

	@objc private func swipeOnLabel() {
		guard let view = view as? BackgroundView else { return }
		if view.screenLabel.text?.isEmpty == false {
			if view.screenLabel.text != zero {
				view.screenLabel.text?.removeLast()
				if view.screenLabel.text?.first == nil {
					view.screenLabel.text = zero
				}
			}
			else {
				view.screenLabel.text = zero
			}
		}
	}
}
