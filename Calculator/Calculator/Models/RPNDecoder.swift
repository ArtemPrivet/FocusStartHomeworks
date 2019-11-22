//
//  RPNDecoder.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 22.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
// 	swiftlint:disable cyclomatic_complexity
//  swiftlint:disable force_unwrapping
//  swiftlint:disable function_body_length

import Foundation

struct RPNDecoder
{
	let double: Double

	private static func evaluatedRPN(expressionInArrayFormat: [String]) -> Double {
		var stack = [String]()

		for (index, sign) in expressionInArrayFormat.enumerated() {
			switch sign {
			case Sign.plus:
				guard stack.count > 1 else { break }
				guard let rightOperand = stack.popLast() else { fallthrough }
				guard let leftOperand = stack.popLast() else { fallthrough }
				stack.append(String(Double(leftOperand)! + Double(rightOperand)!))

			case Sign.minus:
				guard stack.count > 1 else { break }
				guard let rightOperand = stack.popLast() else { fallthrough }
				guard let leftOperand = stack.popLast() else { fallthrough }
				stack.append(String(Double(leftOperand)! - Double(rightOperand)!))

			case Sign.multiply:
				guard stack.count > 1 else { break }
			guard let rightOperand = stack.popLast() else { fallthrough }
				guard let leftOperand = stack.popLast() else { fallthrough }
				stack.append(String(Double(leftOperand)! * Double(rightOperand)!))

			case Sign.divide:
				guard stack.count > 1 else { break }
				guard let rightOperand = stack.popLast() else { fallthrough }
				guard let leftOperand = stack.popLast() else { fallthrough }
				stack.append(String(Double(leftOperand)! / Double(rightOperand)!))
			case Sign.changeSign:
				guard stack.count > 1 else { break }
				guard let rightOperand = stack.popLast() else { fallthrough }
				stack.removeLast()
				print(stack)
				stack.append(String(Double(rightOperand)!))
			case Sign.percent:
				if stack.isEmpty == false {
				guard let rightOperand = stack.popLast() else { fallthrough }
				guard let leftOperand = stack.popLast() else { fallthrough }
				let cachedValue = Double(leftOperand)!
				let percentFromcachedValue = (Double(leftOperand)! * Double(rightOperand)!) / 100
					switch expressionInArrayFormat[index + 1]{
					case Sign.plus:
						stack.append(String(cachedValue + percentFromcachedValue))
					case Sign.minus:
						stack.append(String(cachedValue - percentFromcachedValue))
					case Sign.multiply:
						stack.append(String(cachedValue * percentFromcachedValue))
					case Sign.divide:
						stack.append(String(cachedValue / percentFromcachedValue))
					default: break
					}
				}
			default:
				stack.append(sign)
			}
		}

		guard let result = Double(stack.removeLast()) else { return 0 }

		return result
	}

	init(expressionInArrayFormat: [String]) {
		self.double = RPNDecoder.evaluatedRPN(expressionInArrayFormat: expressionInArrayFormat)
	}
}
