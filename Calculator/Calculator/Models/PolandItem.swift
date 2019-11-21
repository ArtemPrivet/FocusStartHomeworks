//
//  PolandItem.swift
//  Calculator
//
//  Created by Иван Медведев on 19/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

enum PolandItem
{
	case number(Double)
	case sign(Sign)
}

enum Sign: String
{
	case plus = "+"
	case minus = "-"
	case divide = "÷"
	case multiply = "×"
}

func polandScript(input array: [PolandItem]) -> [PolandItem] {
	var stack = Stack<PolandItem>()
	var result: [PolandItem] = []

	array.forEach { item in
		switch item {
		case .number:
			result.append(item)
		case .sign(let sign):
			switch sign {
			case .plus, .minus:
				if let stackTop = stack.top, let isEqualPriopity = isEqualPriority(polandItem: stackTop, sign: sign) {
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
				if let stackTop = stack.top, let isEqualPriopity = isEqualPriority(polandItem: stackTop, sign: sign) {
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

func isEqualPriority(polandItem: PolandItem, sign: Sign) -> Bool? {
	switch polandItem {
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

func polandScriptToStringArray(input array: [PolandItem]) -> [String] {
	var stringArray: [String] = []
	for item in array {
		switch item {
		case .number(let number):
			stringArray.append(String(number))
		case .sign(let sign):
			stringArray.append(sign.rawValue)
		}
	}
	return stringArray
}

func polandScriptGetResult(input array: [String]) -> Double? {
	var stack = Stack<Double>()

	array.forEach { item in
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
	guard let resultOfPolandScript = stack.pop() else { return nil }
	return resultOfPolandScript
}

// Функция проверки разных приоритетов: ДОДЕЛАТЬ
//func containDifferentPrioritySigns(input array: [PolandItem]) -> Bool {
//	let firstPriority = false
//	let secondPriority = false
//	let result = array.contains { item -> Bool in
//		switch item {
//		case .sign(let sign):
//			switch sign {
//			case .plus, .minus:
//				print("PLUS")
//			case .multiply, .divide:
//				print("MUL")
//			}
//		case .number(_):
//			return false
//		}
//	}
//	return result
//}
