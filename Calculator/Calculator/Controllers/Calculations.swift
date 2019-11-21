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
	private var previousOperation: PendingBinaryOperationInfo?
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
		guard let operation = operations[symbol] else { return }
		switch operation {
		case .unaryOperation(let function):
			accumulator = function(accumulator)
			previousAccumulator = accumulator
		case .binaryOperation(let function, let priority):
			if pending.count > 0 {
				if previousPriority > priority {
					executePendingOperations()
				}
				else if previousPriority == priority {
					executeLastPendingOperation()
				}
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
			if pending.count > 0 {
				if let function = pending.last?.function {
					previousOperation = PendingBinaryOperationInfo(function: function, firstOperand: accumulator)
				}
				executePendingOperations()
			}
			else if let operation = previousOperation {
				accumulator = operation.function(accumulator, operation.firstOperand)
			}
			previousAccumulator = accumulator
		case .clear:
			clear()
		}
	}
	private func clear() {
		accumulator = 0.0
		previousAccumulator = 0.0
		pending = []
		previousOperation = nil
	}
	//Выполняем все отложенные операции из массива
	private func executePendingOperations() {
		while pending.count > 0 {
			executeLastPendingOperation()
		}
	}
	//Выполним последнюю отложенную операцию
	private func executeLastPendingOperation() {
		let operation = pending.removeLast()
		accumulator = operation.function(operation.firstOperand, accumulator)
	}
}
