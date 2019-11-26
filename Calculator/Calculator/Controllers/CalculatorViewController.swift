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
	private let calculation = Calculation()
	private let screen = Screen()

	override func loadView() {
		self.view = screen
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		addTargets()
		addGestureRecognizer()
	}

	private func addTargets() {
		for button in screen.button.buttonArray {
			button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
		}
	}

	@objc private func buttonTapped(_ sender: UIButton) {
		guard let title = sender.titleLabel?.text else { return }
			switch title {
			case "0":
				screen.windowLabel.text = calculation.nullTapped()
			case "1", "2", "3", "4", "5", "6", "7", "8", "9":
				screen.windowLabel.text = calculation.numberTapped(sender)
				screen.button.setTitleForACButton("C")
			case ",":
				screen.windowLabel.text = calculation.symbolTapped()
				screen.button.setTitleForACButton("C")
			case "C":
				screen.windowLabel.text = calculation.aCTapped()
				screen.button.setTitleForACButton("AC")
			case "=":
				screen.windowLabel.text = calculation.equalTapped()
			case "+":
				screen.windowLabel.text = calculation.plusTapped()
			case "-":
				screen.windowLabel.text = calculation.minusTapped()
			case "×":
				screen.windowLabel.text = calculation.multiplyTapped()
			case "÷":
				screen.windowLabel.text = calculation.divideTapped()
			case "⁺∕₋":
				screen.windowLabel.text = calculation.opposideTapped()
			case "%":
				screen.windowLabel.text = calculation.procentTapped()
			default:
				break
		}
	}

	private func addGestureRecognizer() {
		let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLabel))
		swipe.direction = [.left, .right]
		screen.windowLabel.isUserInteractionEnabled = true
		screen.windowLabel.addGestureRecognizer(swipe)
	}

	@objc private func swipeLabel() {
		if screen.windowLabel.text != "0" {
			screen.windowLabel.text?.removeLast()
		}
	}
}
