//
//  AppSetting.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 18.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

enum AppSetting
{

	enum Color
	{
		static let main = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
		static let lightText = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		static let darkText = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		static let background = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		static let digit = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
		static let mainOperator = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
		static let otherOperator = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
	}

	enum SymbolIcon
	{
		static let multiple = #imageLiteral(resourceName: "multiply")
		static let divide = #imageLiteral(resourceName: "divide")
		static let magnitude = #imageLiteral(resourceName: "magnitude")
//		static let plus = #imageLiteral(resourceName: "divide")
//		static let minus = #imageLiteral(resourceName: "divide")
//		static let equals = #imageLiteral(resourceName: "divide")
	}
}
