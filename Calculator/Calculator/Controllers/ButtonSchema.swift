//
//  ButtonSchema.swift
//  Calculator
//
//  Created by Stanislav on 22/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

struct ButtonSchema
{
	let hexBackgroundColor: String
	let hexTitleColor: String
	let fontName: String
	let fontSize: CGFloat
	let hexAnimateBackgroundColor: String
	let hexToggleBackgroundColor: String?
	let hexToggleTitleColor: String?

	init(hexBackgroundgColor: String,
		 hexTitleColor: String,
		 fontName: String,
		 fontSize: CGFloat,
		 hexAnimateBackgroundColor: String,
		 hexToggleBackgroundColor: String? = nil,
		 hexToggleTitleColor: String? = nil ) {
		self.hexBackgroundColor = hexBackgroundgColor
		self.hexTitleColor = hexTitleColor
		self.fontName = fontName
		self.fontSize = fontSize
		self.hexAnimateBackgroundColor = hexAnimateBackgroundColor
		self.hexToggleBackgroundColor = hexToggleBackgroundColor
		self.hexToggleTitleColor = hexToggleTitleColor
	}
}
