//
//  PendingResult.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 23/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation
final class PendingResult
{
	weak var delegateToScreen: IPendingResult?
	weak var delegateFromScreen: IDisplayInfo?
	weak var buttonDelegate: IChangeAC?

	private var buttonIdentifier = 0
	private var currentOperator = ""
	private var resultDisplayed: Double = 0
	private var resultNumber = 0
	private var firstOperand = 0.0
	private var secondOperand = 0.0
	private var isPressedAcButton = false
	private var isFloatNumber = false
	private var rpnExpression = [String]()
	private var converterRpn = RPN()
	private var stillTyping = false

	var infoFromDisplay: String?

	var currentInput: Double {
		get {
			guard let text = infoFromDisplay else { return 0 }
			return Double(text) ?? 0
		}
		set {
				// MARK: display upd, setter of currentInput
				infoFromDisplay = String(newValue)
				delegateToScreen?.showResult(result: newValue)
		}
	}

	private func getPriority(str: String) -> Int {
		switch str {
		case "+", "-": return 1
		case "×", "÷": return 2
		default: return 1
		}
	}

	private func makeOperation(_ operation: (Double, Double) -> Double) {
		if stillTyping && rpnExpression.count > 2 {
			if getPriority(str: rpnExpression[rpnExpression.count - 2]) >= getPriority(str: currentOperator) {
				currentInput = converterRpn.evaluateRpn(elements: rpnExpression)
			}
			else {
				currentInput = operation(firstOperand, secondOperand)
			}
		}
		stillTyping = false
	}
}

extension PendingResult: IButton
{
	func getButtonDetails(identifier: Int) {
		buttonIdentifier = identifier
	}

	func allClear() {
		rpnExpression.removeAll()
		firstOperand = 0
		secondOperand = 0
		currentInput = 0
		stillTyping = false
		currentOperator = ""
		isFloatNumber = false
	}

	func clear() {}

	func plusMinus() {
		currentInput *= -1
		// MARK: func plusMinus - display UPD
		delegateToScreen?.showResult(result: currentInput)
	}

	func percent() {
		if firstOperand == 0 {
			currentInput /= 100
			// MARK: func percent - display UPD
			delegateToScreen?.showResult(result: currentInput)
		}
		else {
			currentInput = firstOperand * currentInput / 100
			secondOperand = currentInput
			delegateToScreen?.showResult(result: currentInput)
		}
	}

	func operatorPressed(is oper: String) {
		currentOperator = oper
		if stillTyping {
			rpnExpression.append(String(currentInput))
		}
		if stillTyping && rpnExpression.count > 2 {
			if getPriority(str: rpnExpression[rpnExpression.count - 2]) >= getPriority(str: currentOperator) {
				currentInput = converterRpn.evaluateRpn(elements: rpnExpression)
				// MARK: func operatorPressed - display UPD
				delegateToScreen?.showResult(result: currentInput)
			}
		}
		if stillTyping {
			rpnExpression.append(oper)
		}
		firstOperand = currentInput
		stillTyping = false
		isFloatNumber = false
	}

	func digit(inputText: String) {
		buttonDelegate?.changeAC(state: "C")
		guard stillTyping || buttonIdentifier != 0 else { return }
		if stillTyping {
			if (infoFromDisplay?.count ?? 0) < 9 {
				let unwrappedDisplayInfo: String = infoFromDisplay ?? " "
				if let newText = Double(unwrappedDisplayInfo + inputText) {
				// MARK: func digit  - display UPD
				delegateToScreen?.showResult(result: newText)
				}
			}
		}
		else {
			if let newText = Double(inputText) {
			delegateToScreen?.showResult(result: newText)
			}
			stillTyping = true
		}
	}

	func comma() {
		if stillTyping && isFloatNumber == false {
			infoFromDisplay = (infoFromDisplay ?? "") + "."
			isFloatNumber = true
		}
		else if stillTyping == false && isFloatNumber == false {
			currentInput = Double(infoFromDisplay ?? "") ?? 0.0
			// MARK: func comma - display UPD
			stillTyping = true
		}
	}

	func equalTo() {
		if stillTyping {
			rpnExpression.append(String(currentInput))
			secondOperand = currentInput
		}
		switch currentOperator {
		case "+": makeOperation { $0 + $1 }
		case "-": makeOperation { $0 - $1 }
		case "×": makeOperation { $0 * $1 }
		case "÷": makeOperation { $0 / $1 }
		default: break
		}
		rpnExpression.removeAll()
		firstOperand = currentInput
		stillTyping = true
		isFloatNumber = false
	}
}

extension PendingResult: IDisplayInfo
{
	func displayingNow(nowText: String?) {
		infoFromDisplay = String(nowText?.filter { !" ".contains($0) } ?? "")
	}
	func updDisplayInfo(text: String?) {
		infoFromDisplay = String(text?.filter { !" ".contains($0) } ?? "")
	}
}
