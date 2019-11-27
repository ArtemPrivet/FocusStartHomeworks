//
//  RPNEncoder.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 22.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

struct RPNConverter
{
	///определяем приоритет операции
	private func operatorPriority(_ operatorSign: String) -> Int {
		switch operatorSign {
		case Sign.plus, Sign.minus:
			return 1
		case Sign.multiply, Sign.divide:
			return 2
		case Sign.percent, Sign.changeSign:
			return 3
		default: // числа
			return -1
		}
	}

	/// конвертируем выражение  в обратную польскую нотацию
	func getRPNFrom(inputExpressionsArray: [String]) -> [String] {
		var stack = [String]()
		var output = [String]()
		// алгоритм
		for item in inputExpressionsArray {
			switch operatorPriority(item) {
			case -1: output.append(item)
			case 0: stack.append(item)
			case 4:
				while let last = stack.last {
					if operatorPriority(last) != 0 {
						output.append(stack.removeLast())
					}
					else {
						stack.removeLast()
					}
				}
			default:
				while let last = stack.last {
					if operatorPriority(last) >= operatorPriority(item) {
						output.append(stack.removeLast())
					}
					else {
						break
					}
				}
				stack.append(item)
			}
		}

		while stack.last != nil {
			output.append(stack.removeLast())
		}

		return output
	}

	func getDoubleFromRPN(expressionInArrayFormat: [String]) -> Double {
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
}
