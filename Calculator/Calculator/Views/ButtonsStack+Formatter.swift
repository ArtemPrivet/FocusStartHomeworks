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
		//formatter.usesSignificantDigits = true
		//formatter.maximumSignificantDigits = 9
		formatter.maximumFractionDigits = 7
		formatter.notANumberSymbol = "Error"
		formatter.groupingSeparator = " "
		formatter.locale = Locale.current
		return formatter
	}
}
