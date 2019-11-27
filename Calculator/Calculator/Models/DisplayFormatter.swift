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
		formatter.notANumberSymbol = "Error"
		formatter.maximumFractionDigits = 8
		formatter.groupingSeparator = " "
		formatter.locale = Locale.current
		formatter.positiveInfinitySymbol = "Error"
		formatter.negativeInfinitySymbol = "Error"
		return formatter
	}

	/// если число длинное то на экране будет отображаться число в экспоненте
	 static func automaticNumberStyle(with number: Double) -> NumberFormatter.Style {
		let maxNumber = 999_999_999.0
		return ( number > maxNumber || number < -maxNumber) ? .scientific : .decimal
	}

	private init() {}
}
