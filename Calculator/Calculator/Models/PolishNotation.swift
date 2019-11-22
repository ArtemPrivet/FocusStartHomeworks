//
//  PolandItem.swift
//  Calculator
//
//  Created by Иван Медведев on 19/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

struct PolishNotation
{
	private func convertToReversePolishNotation(_ items: [Item]) -> [Item] {
		var stack = Stack<Item>()
		var result: [Item] = []

		items.forEach { item in
			switch item {
			case .number:
				result.append(item)
			case .sign(let sign):
				switch sign {
				case .plus, .minus:
					if let stackTop = stack.top, let isEqualPriopity = isEqualPriority(item: stackTop, sign: sign) {
						if isEqualPriopity {
							result.append(stackTop)
							_ = stack.pop()
							stack.push(newElement: .sign(sign))
						}
						else {
							result.append(stackTop)
							_ = stack.pop()
							stack.push(newElement: .sign(sign))
						}
					}
					else {
						stack.push(newElement: .sign(sign))
						break
					}
				case .divide, .multiply:
					if let stackTop = stack.top, let isEqualPriopity = isEqualPriority(item: stackTop, sign: sign) {
						if isEqualPriopity {
							result.append(stackTop)
							_ = stack.pop()
							stack.push(newElement: .sign(sign))
						}
						else {
							stack.push(newElement: .sign(sign))
						}
					}
					else {
						stack.push(newElement: .sign(sign))
						break
					}
				}
			}
		}
		while stack.isEmpty == false {
			guard let elementFromStack = stack.pop() else { break }
			result.append(elementFromStack)
		}
		return result
	}

	private func isEqualPriority(item: Item, sign: Sign) -> Bool? {
		switch item {
		case .sign(let stackTopSign):
			switch stackTopSign {
			case .divide, .multiply:
				switch sign {
				case .divide, .multiply:
					return true
				case .minus, .plus:
					return false
				}
			case .plus, .minus:
				switch sign {
				case .divide, .multiply:
					return false
				case .minus, .plus:
					return true
				}
			}
		default:
			return nil
		}
	}

	private func convertPolishScriptNotationToStringArray(_ items: [Item]) -> [String] {
		var stringArray: [String] = []
		for item in items {
			switch item {
			case .number(let number):
				stringArray.append(String(number))
			case .sign(let sign):
				stringArray.append(sign.rawValue)
			}
		}
		return stringArray
	}

	private func getResult(_ items: [String]) -> Double? {
		var stack = Stack<Double>()

		items.forEach { item in
			if item == "+" || item == "÷" || item == "×" || item == "-" {
				var result = 0.0
				guard let value1 = stack.pop() else { return }
				guard let value2 = stack.pop() else { return }
				if item == "+" {
					result = value2 + value1
					stack.push(newElement: result)
				}
				if item == "-" {
					result = value2 - value1
					stack.push(newElement: result)
				}
				if item == "÷" {
					result = value2 / value1
					stack.push(newElement: result)
					print(value2 / value1)
				}
				if item == "×" {
					result = value2 * value1
					stack.push(newElement: result)
				}
			}
			else {
				guard let value = Double(item.replacingOccurrences(of: ",", with: ".")) else { return }
				stack.push(newElement: value)
			}
		}
		guard let resultOfPolishScript = stack.pop() else { return nil }
		return resultOfPolishScript
	}

	func makeCalculation(_ items: [Item]) -> Double? {
		let reversePolishNotation = self.convertToReversePolishNotation(items)
		let stringArray = self.convertPolishScriptNotationToStringArray(reversePolishNotation)
		return self.getResult(stringArray)
	}
}
