//
//  ICalculatorButtonsActions.swift
//  Calculator
//
//  Created by Иван Медведев on 01/12/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

protocol ICalculatorButtonsActions
{
	func allClear()
	func clear()
	func plusMinusSign()
	func percent()
	func addAction()
	func subtractAction()
	func multiplyAction()
	func divideAction()
	func equal()
	func comma()
	func digit(inputText: String)
}
