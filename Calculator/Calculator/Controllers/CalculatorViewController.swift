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
	private var operand = ""
	private var calculateView: CalculatorView?
	private var buttonsService = ButtonsService()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .black
		view.translatesAutoresizingMaskIntoConstraints = false
		self.view = CalculatorView(frame: self.view.frame)
		guard let view = view as? CalculatorView else { return }
		view.delegate = self
	}

	private func operandSettings(_ view: CalculatorView) {
		if buttonsService.divisionButtonTapped {
			view.calculatingLabel.text = ""
			buttonsService.divisionButtonTapped = false
			operand = "/"
		}
		else if buttonsService.multipleButtonTapped {
			view.calculatingLabel.text = ""
			buttonsService.multipleButtonTapped = false
			operand = "*"
		}
		else if buttonsService.minusButtonTapped {
			view.calculatingLabel.text = ""
			buttonsService.minusButtonTapped = false
			operand = "-"
		}
		else if buttonsService.plusButtonTapped {
			view.calculatingLabel.text = ""
			buttonsService.plusButtonTapped = false
			operand = "+"
		}
	}
}

extension CalculatorViewController: TappedButtonsDelegate
{
	func deleteNumber() {
		guard let view = view as? CalculatorView else { return }
		if view.calculatingLabel.text != "0" {
			if view.calculatingLabel.text?.count == 1 {
				view.calculatingLabel.text = "0"
			}
			else {
				view.calculatingLabel.text?.removeLast()
			}
		}
		buttonsService.updateACButtonTitle(view)
	}

	func tappedButtons(_ sender: UIButton) {
		guard let view = view as? CalculatorView else { return }
		operandSettings(view)
		switch sender.tag {
		case 0..<10:
			buttonsService.numbersTapped(view, sender)
		case 10:
			buttonsService.ACTapped(view)
		case 11:
			buttonsService.oppositeSignTapped(view)
		case 12:
			buttonsService.percentTapped(view)
		case 13:
			buttonsService.divisionTapped(view)
		case 14:
			buttonsService.multipleTapped(view)
		case 15:
			buttonsService.minusTapped(view)
		case 16:
			buttonsService.plusTapped(view)
		case 17:
			buttonsService.equallyTapped(view, operand)
		default:
			print("switch error")
		}
		buttonsService.updateACButtonTitle(view)
	}
}
