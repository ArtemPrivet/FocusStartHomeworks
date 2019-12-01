//
//  CalculatorEngine.swift
//  Calculator
//
//  Created by Иван Медведев on 29/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

struct CalculatorEngine
{
	var polandItems: [Item] = []
	let polishNotation = PolishNotation()
	var lastInputItems: [Item] = []
	var lastInputSign: Sign?
	var isNewValue = true

	mutating func allClearCalculation() {
		self.polandItems.removeAll()
		self.isNewValue = true
		self.lastInputItems.removeAll()
		self.lastInputSign = nil
	}

	mutating func clearCalculation() {
		self.isNewValue = true
	}

	mutating func percent(input: String?) -> String? {
		if self.polandItems.count == 1 {
		}
		else {
			guard let inputNotNil = input?.replacingOccurrences(of: ",", with: ".") else { return nil }
			guard let number = Double(inputNotNil) else { return nil }
			let item = Item.number(number)

			self.polandItems.append(item)
		}
		return nil
	}

	mutating func addAction(input: String?) -> String? {
		guard let result = self.makeAction(input: input, sign: .plus) else { return nil }
		return result
	}

	mutating func subtractAction(input: String?) -> String? {
		guard let result = self.makeAction(input: input, sign: .minus) else { return nil }
		return result
	}

	mutating func multiplyAction(input: String?) -> String? {
		guard let result = self.makeAction(input: input, sign: .multiply) else { return nil }
		return result
	}

	mutating func divideAction(input: String?) -> String? {
		guard let result = self.makeAction(input: input, sign: .divide) else { return nil }
		return result
	}

	mutating func resultAction(input: String?) -> String? {

		guard let inputNotNil = input?.replacingOccurrences(of: ",", with: ".") else { return nil }
		guard let number = Double(inputNotNil) else { return nil }
		let item = Item.number(number)

		guard let lastItem = self.lastItem() else { return nil }
		if isNewValue {
			self.polandItems.append(item)
			self.isNewValue = false
			self.lastInputItems.removeAll()
			if let sign = self.lastInputSign {
				self.lastInputItems.append(.sign(sign))
				self.lastInputItems.append(item)
			}
		}
		else if lastItem == "number" {
			self.lastInputItems.forEach { self.polandItems.append($0) }
		}
		else {
			self.polandItems.removeLast()
			self.lastInputItems.removeAll()
			if let sign = self.lastInputSign {
				self.lastInputItems.append(.sign(sign))
				self.lastInputItems.append(item)
			}
			self.lastInputItems.forEach { self.polandItems.append($0) }
		}
		guard self.polandItems.count >= 3 else { return nil }

			guard let resultInString = self.polishNotation.makeCalculationToString(self.polandItems) else { return nil }
			guard let resultInDouble = self.polishNotation.makeCalculationToDouble(self.polandItems) else { return nil }
			self.polandItems.removeAll()
			self.polandItems.append(.number(resultInDouble))
			return resultInString
	}
}

extension CalculatorEngine
{
	private mutating func makeAction(input: String?, sign: Sign) -> String? {
		guard let inputNotNil = input?.replacingOccurrences(of: ",", with: ".") else { return nil }
		guard let number = Double(inputNotNil) else { return nil }
		let item = Item.number(number)

		if isNewValue {
			self.polandItems.append(item)
			self.isNewValue = false
		}

		self.lastInputSign = sign

		guard let lastItem = self.lastItem() else { return nil }

		if lastItem == "number" {
			self.polandItems.append(.sign(sign))
		}
		else {
			self.polandItems.removeLast()
			self.polandItems.append(.sign(sign))
			return nil
		}

		switch sign {
		case .plus, .minus:
			if self.secondLastSign() != nil {
				let items = Array(self.polandItems[0 ..< self.polandItems.count - 1])
				guard let resultInString = self.polishNotation.makeCalculationToString(items) else { return nil }
				return resultInString
			}
		case .multiply, .divide:
			if let secondLastSign = self.secondLastSign() {
				if secondLastSign == "multiply" || secondLastSign == "divide" {
					let items = Array(self.polandItems[0 ..< self.polandItems.count - 1])
					guard let resultInString = self.polishNotation.makeCalculationToString(items) else { return nil }
					return resultInString
				}
			}
		}
		return nil
	}

	private func lastItem() -> String? {
		guard let lastItem = self.polandItems.last else { return nil }
		switch lastItem {
		case .number:
			return "number"
		case .sign(.plus):
			return "plus"
		case .sign(.minus):
			return "minus"
		case .sign(.divide):
			return "divide"
		case .sign(.multiply):
			return "multiply"
		}
	}

	private func secondLastSign() -> String? {
		let secondLastSign = self.polandItems[0 ..< self.polandItems.count - 1].last { item -> Bool in
			switch item {
			case .sign:
				return true
			default:
				return false
			}
		}
		guard let sign = secondLastSign else { return nil }
		switch sign {
		case .sign(.plus):
			return "plus"
		case .sign(.minus):
			return "minus"
		case .sign(.multiply):
			return "multiply"
		case .sign(.divide):
			return "divide"
		default:
			return nil
		}
	}
}
