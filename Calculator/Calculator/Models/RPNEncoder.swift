//
//  RPNEncoder.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 22.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

struct RPNEncoder
{
	var expressionsAsRPN = [String]() //  массив выражений сконвертированный в RPN
	private var inputExpressionsArray = [String]() // входной массив (с обычнымми выражениями)
	var rpnString = "" // строка вывода после конвертации в RPN

	///определяем приоритет операции
	static func operatorPriority(_ operatorSign: String) -> Int {
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

	/// инициализируемся с массивом выражений
	init(_ expressionInArrayFormat: [String]) {
		self.inputExpressionsArray = expressionInArrayFormat
		self.toRPN()
	}

	/// конвертируем выражение которое передали в инициализатор
	private mutating func toRPN() {
		var stack = [String]()
		var output = [String]()
		// польская бесовщина
		for item in inputExpressionsArray {
			switch RPNEncoder.operatorPriority(item) {
			case -1: output.append(item)
			case 0: stack.append(item)
			case 4:
				while let last = stack.last {
					if RPNEncoder.operatorPriority(last) != 0 {
						output.append(stack.removeLast())
					}
					else {
						stack.removeLast()
					}
				}
			default:
				while let last = stack.last {
					if RPNEncoder.operatorPriority(last) >= RPNEncoder.operatorPriority(item) {
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

		expressionsAsRPN = output
		rpnString = output.joined(separator: Sign.arrayExpressionSeparator)
	}
}
