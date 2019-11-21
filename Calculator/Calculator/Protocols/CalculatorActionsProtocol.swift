//
//  CalculatorActionsProtocol.swift
//  Calculator
//
//  Created by Иван Медведев on 19/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

protocol CalculatorActionsProtocol: AnyObject
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
