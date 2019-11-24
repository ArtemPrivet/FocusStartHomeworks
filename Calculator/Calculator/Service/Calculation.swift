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
		guard labelText.count <= 8 else { return labelText }
		if firstValue {
			labelText = "0"
			firstValue = false
		}
		else if labelText.first != "0" {
			labelText += "0"
		}
		return labelText
	}

	func numberTapped(_ sender: UIButton) -> String? {
		guard labelText.count <= 8 else { return labelText }
		if firstValue {
			labelText = sender.titleLabel?.text ?? ""
			firstValue = false
		}
		else if labelText != "0" {
			labelText += sender.titleLabel?.text ?? ""
		}
		else {
			labelText = sender.titleLabel?.text ?? ""
		}
		return labelText
	}

	func aCTapped() -> String {
		firstValue = true
		labelText = "0"
		return labelText
	}

	func symbolTapped() -> String {
		guard labelText.count <= 8 else { return labelText }
		guard labelText.filter(",".contains).isEmpty else { return labelText }
		if firstValue {
			labelText = "0,"
			firstValue = false
		}
		else {
			labelText += ","
		}
		return labelText
	}

	func equalTapped() -> String {
		var result: Double?
		labelText = String(labelText.map { $0 == "," ? "." : $0 })
		if let finalOperator = lastOperator {
			switch finalOperator {
			case .plus: result = (subTotal ?? 0) + (Double(labelText) ?? 0)
			case .minus: result = (subTotal ?? 0) - (Double(labelText) ?? 0)
			case .multiply: result = (subTotal ?? 0) * (Double(labelText) ?? 0)
			case .divide: result = (subTotal ?? 0) / (Double(labelText) ?? 0)
			}
		}
		labelText = convertToInt(result ?? 0)
		subTotal = nil
		firstValue = true
		return labelText
	}

	func plusTapped() -> String {
		labelText = String(labelText.map { $0 == "," ? "." : $0 })
		if let currentSubTotal = subTotal {
			subTotal = (Double(labelText) ?? 0) + currentSubTotal
		}
		else {
			subTotal = (Double(labelText) ?? 0)
		}
		labelText = convertToInt(subTotal ?? 0)
		lastOperator = .plus
		firstValue = true
		return labelText
	}

	func minusTapped() -> String {
		labelText = String(labelText.map { $0 == "," ? "." : $0 })
		if let currentSubTotal = subTotal {
			subTotal = (Double(labelText) ?? 0) - currentSubTotal
		}
		else {
			subTotal = (Double(labelText) ?? 0)
		}
		labelText = convertToInt(subTotal ?? 0)
		lastOperator = .minus
		firstValue = true
		return labelText
	}

	func multiplyTapped() -> String {
		labelText = String(labelText.map { $0 == "," ? "." : $0 })
		if let currentSubTotal = subTotal {
			subTotal = (Double(labelText) ?? 0) * currentSubTotal
		}
		else {
			subTotal = (Double(labelText) ?? 0)
		}
		labelText = convertToInt(subTotal ?? 0)
		lastOperator = .multiply
		firstValue = true
		return labelText
	}

	func divideTapped() -> String {
		labelText = String(labelText.map { $0 == "," ? "." : $0 })
		if let currentSubTotal = subTotal {
			subTotal = (Double(labelText) ?? 0) / currentSubTotal
		}
		else {
			subTotal = (Double(labelText) ?? 0)
		}
		labelText = convertToInt(subTotal ?? 0)
		lastOperator = .divide
		firstValue = true
		return labelText
	}

	func opposideTapped() -> String {
		labelText = String(labelText.map { $0 == "," ? "." : $0 })
		if labelText.first != "-" {
			labelText = "-" + labelText
		}
		else {
			labelText.removeFirst()
		}
		labelText = String(labelText.map { $0 == "." ? "," : $0 })
		return labelText
	}

	func procentTapped() -> String {
		labelText = String(labelText.map { $0 == "," ? "." : $0 })
		labelText = String((Double(labelText) ?? 0) / 100.0)
		labelText = String(labelText.map { $0 == "." ? "," : $0 })
		return labelText
	}

	func convertToInt(_ number: Double) -> String {
		guard number.isInfinite == false else {
			labelText = "Ошибка"
			return labelText
		}
		if number.rounded() == number {
			labelText = "\(Int(number))"
		}
		else {
			labelText = String(round(10000000 * number) / 10000000)
		}
		labelText = String(labelText.map { $0 == "." ? "," : $0 })
		return labelText
	}
}
