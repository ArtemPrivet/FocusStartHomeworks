//
//  Formatter.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 19.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

extension ButtonsStack
{
	var formatter: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.usesGroupingSeparator = true
		formatter.notANumberSymbol = "NaN"
		formatter.groupingSeparator = " "
		formatter.locale = Locale.current
		return formatter
	}
}
