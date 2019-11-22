//
//  LogicViewController.swift
//  Calculator
//
//  Created by MacBook Air on 20.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

//swiftlint:disable all

import UIKit

final class Calculation
{
	var firstValue = true
	var labelText = "0"
	var subTotal: Double?

	enum OperatorType
	{
		case plus
		case subtract
		case multiply
		case divide
	}

	var lastOperator: OperatorType?

	//func multiply(a, b)

	func nullTapped(_ sender: UIButton) {
		guard let title = sender.titleLabel?.text else { return }
		if firstValue {
			labelText = title
		}
		else {
			labelText += title
		}
	}

	@objc func setTarget(_ sender: UIButton) {
			guard let title = sender.titleLabel?.text else { return }

			switch title {
			case "0":
				if firstValue {
					labelText = title
				}
				else {
					labelText += title
				}
			case "1", "2", "3", "4", "5", "6", "7", "8", "9":
				if firstValue {
					labelText = title
					firstValue = false
				}
				else {
					labelText += title
				}
			case ",":
				if firstValue {
					labelText = "."
					firstValue = false
				}
				else {
					labelText += "."
				}

			case "AC":
				labelText = "0"
				firstValue = true
			case "=":
				var result: Double?
				if let finalOperator = lastOperator {
					switch finalOperator {
					case .plus : result = (subTotal ?? 0) + (Double(labelText) ?? 0)
					case .subtract : result = (subTotal ?? 0) - (Double(labelText) ?? 0)
					case .multiply : result = (subTotal ?? 0) * (Double(labelText) ?? 0)
					case .divide : result = (subTotal ?? 0) / (Double(labelText) ?? 0)
					}
				}
				labelText = "\(result ?? 0)"
				subTotal = nil
				firstValue = true
			case "+":
				if let currentSubTotal = subTotal {
						subTotal = (Double(labelText) ?? 0) + currentSubTotal
					} else {
						subTotal = (Double(labelText) ?? 0)
					}
					lastOperator = OperatorType.plus
					firstValue = true
					labelText = "\(subTotal ?? 0)"
			case "-":
				if let currentSubTotal = subTotal {
					subTotal = (Double(labelText) ?? 0) - currentSubTotal
				} else {
					subTotal = (Double(labelText) ?? 0)
				}
				lastOperator = OperatorType.subtract
				firstValue = true
				labelText = "\(subTotal ?? 0)"
			case "×":
			if let currentSubTotal = subTotal {
				 subTotal = (Double(labelText) ?? 0) * currentSubTotal
			 }
			else {
				 subTotal = (Double(labelText) ?? 0)
			 }
			 lastOperator = OperatorType.multiply
			 firstValue = true
			 labelText = "\(subTotal ?? 0)"
			case "÷":
				if let currentSubTotal = subTotal {
					 subTotal = (Double(labelText) ?? 0) / currentSubTotal
				}
				else {
					 subTotal = (Double(labelText) ?? 0)
				 }
				 lastOperator = OperatorType.divide
				 firstValue = true
				 labelText = "\(subTotal ?? 0)"
			default:
				return
			}
			print(labelText)
		}
	}

