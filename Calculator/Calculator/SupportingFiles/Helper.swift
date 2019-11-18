//
//  Helper.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 18.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

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

	struct Color
	{
		private init() { }

		static let main: UIColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
		static let lightText: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		static let darkText: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		static let background: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		static let digit: UIColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
		static let mainOperator: UIColor = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
		static let otherOperator: UIColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
	}
}
