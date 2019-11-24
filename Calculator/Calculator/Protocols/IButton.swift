//
//  IButton.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 23/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

protocol IButton: AnyObject
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
