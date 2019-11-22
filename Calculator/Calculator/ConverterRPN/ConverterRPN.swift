//
//  ConverterRPN.swift
//  Calculator
//
//  Created by Kirill Fedorov on 21.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

final class ConverterRPN
{
	private func operatorPriority(_ oper: String) -> Int {
		switch oper {
		case "+", "-": return 1
		case "*", "/": return 2
		default: return -1
		}
	}

	private func convertToRpn(_ input: [String]) -> [String] {
		var container = [String]()
		var output = [String]()
		for element in input {
			switch operatorPriority(element) {
			case -1: output.append(element)
			case 0: container.append(element)
			case 4:
				while let lastElement = container.last {
					if operatorPriority(lastElement) != 0 {
						output.append(container.removeLast())
					}
					else {
						container.removeLast()
					}
				}
			default:
				while let lastElement = container.last {
					if operatorPriority(lastElement) >= operatorPriority(element) {
						output.append(container.removeLast())
					}
					else {
						break
					}
				}
				container.append(element)
			}
		}
		while container.last != nil {
			output.append(container.removeLast())
		}
		return output
	}

	func evaluateRpn(elements: [String]) -> Double {
		var container = [String]()
		for element in convertToRpn(elements) {
			switch element {
			case "+":
				guard
					let rightOperand = Double(container.removeLast()),
					let leftOperand = Double(container.removeLast()) else { break }
				container.append(String(leftOperand + rightOperand))
			case "-":
				guard
					let rightOperand = Double(container.removeLast()),
					let leftOperand = Double(container.removeLast()) else { break }
				container.append(String(leftOperand - rightOperand))
			case "*":
				guard
					let rightOperand = Double(container.removeLast()),
					let leftOperand = Double(container.removeLast()) else { break }
				container.append(String(leftOperand * rightOperand))
			case "/":
				guard
					let rightOperand = Double(container.removeLast()),
					let leftOperand = Double(container.removeLast()) else { break }
				container.append(String(leftOperand / rightOperand))
			default:
				container.append(element)
			}
		}
		guard container.isEmpty == false else { return 0.0 }
		return Double(container.removeLast()) ?? 0.0
	}
}
