//
//  RPNDecoder.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 22.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

struct RPNDecoder
{
	let double: Double

	private static func evaluatedRPN(expressionInArrayFormat: [String]) -> Double {
		var stack = [String]()

		for (index, sign) in expressionInArrayFormat.enumerated() {
			switch sign {
			case Sign.plus, Sign.minus, Sign.multiply, Sign.divide, Sign.percent:

				guard stack.count > 1 else { break }
				guard let rightOperand = stack.popLast() else { fallthrough }
				guard let leftOperand = stack.popLast() else { fallthrough }

				guard let leftDouble = Double(leftOperand) else { fallthrough }
				guard let rightDouble = Double(rightOperand) else { fallthrough }

				switch sign {
				case Sign.plus: stack.append(String(leftDouble + rightDouble))
				case Sign.minus: stack.append(String(leftDouble - rightDouble))
				case Sign.multiply: stack.append(String(leftDouble * rightDouble))
				case Sign.divide: stack.append(String(leftDouble / rightDouble))

				case Sign.percent:
					let cachedValue = leftDouble
					let percentFromcachedValue = leftDouble * rightDouble / 100
					// определяем следующий знак в массиве
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
				default: break
				}

			case Sign.changeSign:
			//	guard stack.count > 1 else { break }
				guard let rightOperand = stack.popLast() else { fallthrough }
				stack.removeLast()
				if let doubleValue = Double(rightOperand) { stack.append(String(doubleValue)) }

			default:
				//число, добавляем в стек
				stack.append(sign)
			}
		}

		if stack.isEmpty == false {
			guard let result = Double(stack.removeLast()) else { return 0 }
			return result
		}
		return 0
	}

	init(expressionInArrayFormat: [String]) {
		self.double = RPNDecoder.evaluatedRPN(expressionInArrayFormat: expressionInArrayFormat)
	}
}
