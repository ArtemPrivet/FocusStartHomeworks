//
//  ButtonViewCreator.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 20.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

enum ButtonViewCreator
{
	static func createButton(type: ButtonView.`Type`,
							 tapHandler: @escaping ButtonView.Action) -> ButtonView {
		var textSize: CGFloat
		if case .mainOperator = type {
			textSize = 45
		}
		else {
			textSize = 36
		}
		return
			ButtonView(type: type,
					   backgroundColor: Color.background(type).value,
					   textColor: Color.text(type).value,
					   textSize: textSize,
					   tapHandler: tapHandler)
	}

	private enum Color
	{
		case background(ButtonView.`Type`)
		case text(ButtonView.`Type`)

		var value: UIColor {
			switch self {
			case .background(let type):
				return backgroundColor(for: type)
			case .text(let type):
				return textColor(for: type)
			}
		}

		private func backgroundColor(for type: ButtonView.`Type`) -> UIColor {
			switch type {
			case .number, .decimal:
				return AppSetting.Color.digit
			case .mainOperator:
				return AppSetting.Color.mainOperator
			case .other:
				return AppSetting.Color.otherOperator
			}
		}

		private func textColor(for type: ButtonView.`Type`) -> UIColor {
			switch type {
			case .number, .mainOperator, .decimal:
				return AppSetting.Color.lightText
			case .other:
				return AppSetting.Color.darkText
			}
		}
	}
}
