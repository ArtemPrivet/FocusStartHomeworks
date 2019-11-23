//
//  Formatter+Extension.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 23.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

extension Formatter
{
	static let scientific: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .scientific
		formatter.positiveFormat = "0.###E0"
		formatter.exponentSymbol = "e"
		formatter.notANumberSymbol = "Error"
		formatter.locale = Locale.current
		return formatter
	}()

	static let decimal: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 8
		formatter.notANumberSymbol = "Error"
		formatter.groupingSeparator = " "
		formatter.locale = Locale.current
		formatter.groupingSize = 3
		return formatter
	}()
}
