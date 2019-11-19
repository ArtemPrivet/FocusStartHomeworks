//
//  Calculations.swift
//  Calculator
//
//  Created by Stanislav on 18/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

final class Calculations
{
	private var accumulator = 0.0
	private var previousAccumulator = 0.0
	private var previousPriority = Int.max
	private var pending: [PendingBinaryOperationInfo] = []
	var result: Double {
		return accumulator
	}
	//Сохраняем в структуру инфу по отложенной операции: первого оператора и саму функцию
	private struct PendingBinaryOperationInfo
	{
		var function: ((Double, Double) -> Double)
		var firstOperand: Double
	}
	private enum CalcOperation
	{
		case unaryOperation((Double) -> Double)
		case binaryOperation((Double, Double) -> Double, Int)
		case percentOperation((Double) -> Double, (Double, Double) -> Double)
		case equals
		case clear
	}
	//Складываем все замыкания по операциям
	private var operations: [String: CalcOperation] = [
		"+/-": CalcOperation.unaryOperation{ -$0 },
		"%": CalcOperation.percentOperation({ $0 / 100 }, { $0 * $1 / 100 }),
		"＋": CalcOperation.binaryOperation({ $0 + $1 }, 0),
		"－": CalcOperation.binaryOperation({ $0 - $1 }, 0),
		"✕": CalcOperation.binaryOperation({ $0 * $1 }, 1),
		"÷": CalcOperation.binaryOperation({ $0 / $1 }, 1),
		"＝": CalcOperation.equals,
		"C": CalcOperation.clear,
	]
	//Устанавливаем начальное значение
	func setOperand(operand: Double) {
		accumulator = operand
	}
	//Выполняем пришедшую операцию, либо откладываем если операция с двумя операндами
	func makeOperation(symbol: String) {
		if let operation = operations[symbol] {
			switch operation {
			case .unaryOperation(let function):
				accumulator = function(accumulator)
				previousAccumulator = accumulator
			case .binaryOperation(let function, let priority):
				switch pending.count {
				case 1:
					if previousPriority >= priority {
						executePendingOperations()
					}
				case 2:
					executePendingOperations()
				default:
					break
				}
				pending.append(PendingBinaryOperationInfo(function: function,
														  firstOperand: accumulator))
				previousPriority = priority
				previousAccumulator = accumulator
			case .percentOperation(let functionForUnary, let functionForBinary ):
				if pending.count > 0 {
					accumulator = functionForBinary(accumulator, previousAccumulator)
				}
				else {
					accumulator = functionForUnary(accumulator)
				}
				previousAccumulator = accumulator
			case .equals:
				executePendingOperations()
			case .clear:
				clear()
			}
		}
	}
	private func clear() {
		accumulator = 0.0
		previousAccumulator = 0.0
		pending = []
	}
	//Выполняем все отложенные операции из массива
	private func executePendingOperations() {
		for iterator in pending.indices.reversed() {
			accumulator = pending[iterator].function(pending[iterator].firstOperand, accumulator)
			pending.remove(at: iterator)
		}
	}
}
