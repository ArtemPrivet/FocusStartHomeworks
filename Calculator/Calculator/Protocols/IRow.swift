//
//  IRow.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 24/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

protocol IRow: AnyObject
{
	func getButtonDetails(identifier: Int)
	func allClear()
	func clear()
	func plusMinus()
	func percent()
	func operatorPressed(is oper: String)
	func digit(inputText: String)
	func comma()
	func equalTo()
}
