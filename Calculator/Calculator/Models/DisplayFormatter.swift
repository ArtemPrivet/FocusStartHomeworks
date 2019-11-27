//
//  DisplayFormatter.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 19.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

final class DisplayFormatter
{
	static let shared = DisplayFormatter()

	var format: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.usesGroupingSeparator = true
		formatter.notANumberSymbol = "0"
		formatter.maximumFractionDigits = 8
		formatter.groupingSeparator = " "
		formatter.locale = Locale.current
		formatter.positiveInfinitySymbol = "Error"
		return formatter
	}

	private init() {}

	/// если число длинное то на экране будет отображаться число в экспоненте
	 func switchFormatterNumberStyle(with number: Double) {
		let maxNumber = 999_999_999.0
		format.numberStyle = ( number > maxNumber || number < -maxNumber) ? .scientific : .decimal
	}
}
