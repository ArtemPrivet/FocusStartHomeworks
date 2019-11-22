//
//  LogicViewController.swift
//  Calculator
//
//  Created by MacBook Air on 20.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class Calculation
{
	var firstValue = true
	var labelText = "0"
	var subTotal: Double?

	enum OperatorType
	{
		case plus
		case minus
		case multiply
		case divide
	}

	var lastOperator: OperatorType?

	func nullTapped() -> String? {
		if firstValue {
			labelText = "0"
		}
		else {
			labelText += "0"
		}
		return labelText
	}

	func numberTapped(_ sender: UIButton) -> String? {
		if firstValue {
			labelText = sender.titleLabel?.text ?? ""
			firstValue = false
		}
		else {
			labelText += sender.titleLabel?.text ?? ""
		}
		return labelText
	}

	func aCTapped() -> String {
		firstValue = true
		labelText = "0"
		return labelText
	}

	func symbolTapped() -> String {
		if firstValue {
			labelText = "."
			firstValue = false
		}
		else {
			labelText += "."
		}
		return labelText
	}

	func equalTapped() -> String {
		var result: Double?
		if let finalOperator = lastOperator {
			switch finalOperator {
			case .plus: result = (subTotal ?? 0) + (Double(labelText) ?? 0)
			case .minus: result = (subTotal ?? 0) - (Double(labelText) ?? 0)
			case .multiply: result = (subTotal ?? 0) * (Double(labelText) ?? 0)
			case .divide: result = (subTotal ?? 0) / (Double(labelText) ?? 0)
			}
		}
		labelText = convertToInt(result ?? 0)
		subTotal = result
		firstValue = true
		return labelText
	}

	func plusTapped() -> String {
		if let currentSubTotal = subTotal {
			subTotal = (Double(labelText) ?? 0) + currentSubTotal
		}
		else {
			subTotal = (Double(labelText) ?? 0)
		}
		labelText = convertToInt(subTotal ?? 0)
		lastOperator = OperatorType.plus
		firstValue = true
		return labelText
	}

	func minusTapped() -> String {
		if let currentSubTotal = subTotal {
			subTotal = (Double(labelText) ?? 0) - currentSubTotal
		}
		else {
			subTotal = (Double(labelText) ?? 0)
		}
		labelText = convertToInt(subTotal ?? 0)
		lastOperator = OperatorType.minus
		firstValue = true
		return labelText
	}

	func multiply() -> String {
		if let currentSubTotal = subTotal {
			subTotal = (Double(labelText) ?? 0) * currentSubTotal
		}
		else {
			subTotal = (Double(labelText) ?? 0)
		}
		labelText = convertToInt(subTotal ?? 0)
		lastOperator = OperatorType.multiply
		firstValue = true
		return labelText
	}

	func divideTapped() -> String {
		if let currentSubTotal = subTotal {
			subTotal = (Double(labelText) ?? 0) / currentSubTotal
		}
		else {
			subTotal = (Double(labelText) ?? 0)
		}
		labelText = convertToInt(subTotal ?? 0)
		lastOperator = OperatorType.divide
		firstValue = true
		return labelText
	}

	func convertToInt(_ number: Double) -> String {
		if number.rounded() == number {
			labelText = "\(Int(number))"
		}
		else {
			labelText = "\(number)"
		}
		labelText = String(labelText.map { $0 == "." ? "," : $0 })
		return labelText
	}
}
