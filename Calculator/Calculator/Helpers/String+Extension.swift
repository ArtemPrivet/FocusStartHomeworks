//
//  String+Extension.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 18.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

extension String
{
	func maxLength(length: Int) -> String {
		var str = self
		let nsString = str as NSString
		if nsString.length >= length {
			str = nsString.substring(with:
				NSRange(
					location: 0,
					length: nsString.length > length ? length : nsString.length)
			)
		}
		return  str
	}
}
