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
	let calculation = Calculation()
	let screen = Screen()
	var firstValue = true

	override func loadView() {
		self.view = screen
		//self.someLabel = screen.windowLabel
		//someLabel?.text = "333"
		//screen.windowLabel.text = "333"
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		//screen.windowLabel.text = textInLabel
		addTargets()
	}

	func addTargets() {
		for button in screen.button.buttonsArray {
			button.addTarget(self, action: #selector(setTarget), for: .touchUpInside)
		}
	}

	@objc func setTarget(_ sender: UIButton) {
		guard let title = sender.titleLabel?.text else { return }
			switch title {
			case "0":
				screen.windowLabel.text = calculation.nullTapped()
			case "1", "2", "3", "4", "5", "6", "7", "8", "9":
				screen.windowLabel.text = calculation.numberTapped(sender)
				screen.button.buttonsArray[15].titleLabel?.text = " C"
			case ",":
				screen.windowLabel.text = calculation.symbolTapped()
			case "AC":
				screen.windowLabel.text = calculation.aCTapped()
				screen.button.buttonsArray[15].titleLabel?.text = "AC"
			case "=":
				screen.windowLabel.text = calculation.equalTapped()
			case "+":
				screen.windowLabel.text = calculation.plusTapped()
			case "-":
				screen.windowLabel.text = calculation.minusTapped()
			case "×":
				screen.windowLabel.text = calculation.multiply()
			case "÷":
				screen.windowLabel.text = calculation.divideTapped()
			default:
				print("Fuck")
		}
	}

//	@objc func setTarget(button: UIButton) {
//		print("yyyhhh")
////		switch par {
////		case *: self.logic()
////		}
//	}
}
