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
	override func loadView() {
		view = BackgroundView()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		configureButtons()
	}

	private func configureButtons() {
		guard let view = view as? BackgroundView else { return }
		for button in view.buttonsStack.cells {
			button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
		}
	}

	@objc private func buttonTapped(_ sender: UIButton) {
		//Добавить обработку кнопок
		sender.blink()
	}
}
