//
//  Calculator.swift
//  Homework2
//
//  Created by MisnikovRoman on 03.11.2019.
//  Copyright © 2019 MisnikovRoman. All rights reserved.
//

// ЗАДАНИЕ:
// Сделать расширение класса String c 2 методами:
// 1. Метод возвращает строку с развернутыми словам.
// Порядок слов не меняется, меняется порядок букв в словах.
// Пример: "hello world" -> "olleh dlrow"
// Сигнатура метода: .reversedWords() -> String

// 2. Метод проверяет номер мобильного телефона на правильность.
// Коды русских номеров телефонов - 900...999, номер может начинаться
// с '+7', '7' и '8'. Номер можно вводить и со скобками и с черточками
// и пробелами.
// Сигнатура метода: .validate() -> Bool
import Foundation

extension String
{
	func reversedWords() -> String {
		let result = self.components(separatedBy: " ")
			.map { String($0.reversed()) }
			.reduce("", { $0 + $1 + " " })
		return String(result.dropLast())
	}

	func validate() -> Bool {
		let phoneNumber = self.replacingOccurrences(of: " ", with: "")
		let pattern = "^(8|7|\\+7)[\\(]?(9)\\d{2}[\\)]?\\d{3}[\\-]?\\d{2}[\\-]?\\d{2}$"
		do {
			let regex = try NSRegularExpression(pattern: pattern,
												options: .caseInsensitive)
			let result = regex.firstMatch(in: phoneNumber,
										  options: NSRegularExpression.MatchingOptions(rawValue: 0),
										  range: NSRange(location: 0, length: phoneNumber.count)) != nil
			return result
		}
		catch {
			return false
		}
	}
}
