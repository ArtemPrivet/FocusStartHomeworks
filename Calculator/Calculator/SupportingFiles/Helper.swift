//
//  Helper.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 18.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

struct AppSetting
{
	private init() { }

	static let formatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 6
		formatter.notANumberSymbol = "Error"
		formatter.groupingSeparator = " "
		formatter.locale = Locale.current
		return formatter
	}()
}
