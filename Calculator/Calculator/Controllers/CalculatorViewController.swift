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
	private let zero = "0"
	private var calc = Calculator()

	override func loadView() {
		view = BackgroundView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureButtons()
		addSwipeToLabel()
	}

	private func configureButtons() {
		guard let view = view as? BackgroundView else { return }
		for button in view.buttonsStack.cells {
			button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
		}
	}

	private func addSwipeToLabel() {
		guard let view = view as? BackgroundView else { return }
		let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeOnLabel))
		swipeRecognizer.direction = [.left, .right]
		view.screenLabel.isUserInteractionEnabled = true
		view.screenLabel.addGestureRecognizer(swipeRecognizer)
	}

	private func toggleClearButtonTitle() {
		// AC <-> C
		guard let view = view as? BackgroundView else { return }
		view.buttonsStack.cells.first?.setTitle(
			view.screenLabel.text != "0" ? "C" : "AC",
			for: .normal
		)
	}

	private func getUserInput(_ symbol: String?) {
		guard let symbol = symbol else { return }
		guard let view = view as? BackgroundView else { return }
		if Double(symbol) != nil || symbol == Operation.comma.rawValue  {
			if view.screenLabel.text == zero {
				view.screenLabel.text = (symbol == Operation.comma.rawValue) ? zero : ""
			}
			view.screenLabel.text? += symbol
		}
	}

	@objc private func swipeOnLabel() {
		guard let view = view as? BackgroundView else { return }
		//РЕАЛИЗОВАТЬ ОБРАБОТКУ ЖЕСТОВ
		print("swipe")
	}

	@objc private func buttonTapped(_ sender: Button) {
		//Добавить обработку нажатия кнопок
		guard let view = view as? BackgroundView else { return }
		sender.blink()
		getUserInput(sender.currentTitle)
		toggleClearButtonTitle()
	}
}
