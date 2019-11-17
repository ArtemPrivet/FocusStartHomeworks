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

	var buttons = [ButtonView]()
	var resultLabel = UILabel()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .black
		addButtonActions()
	}

	override func loadView() {
		let calcView = CalcalatorView()
		self.view = calcView
		buttons = calcView.buttons
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		roundedButtons()
	}

	func roundedButtons() {
		buttons.forEach { button in
			button.layer.cornerRadius = button.bounds.height / 2
		}
	}

	func addButtonActions() {
		buttons.forEach { button in
			button.addTarget(self, action: #selector(pressSomeButton), for: .touchUpInside)
		}
	}

	@objc func pressSomeButton(_ sender: ButtonView) {
		print(sender.tag)
	}
}
