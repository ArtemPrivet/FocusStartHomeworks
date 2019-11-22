//
//  Sign.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 21.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

enum Sign
{
	static let changeSign = "⁺∕₋"
	static let percent = "%"
	static let divide = "÷"
	static let multiply = "×"
	static let minus = "−"
	static let plus = "+"
	static let equals = "="
	static let clear = "C"
	static let allClear = "AC"
	static let zero = "0"
	static let decimalSeparator = MyFormatter.shared.format.decimalSeparator
	static let arrayExpressionSeparator = " "
}
