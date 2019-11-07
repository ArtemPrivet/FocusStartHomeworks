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

// Надеюсь import можно было сделать))) (Для CharacterSet)
import Foundation

typealias PunctuationMark = (mark: Character, index: Int)

extension String
{
	func reversedWords() -> String {
		let setOfPunctuationMarks: CharacterSet = [" ", ",", ".", "!", "?", ":", "-"]

		var punctuationMarks: [PunctuationMark] = []

		for (index, char) in self.enumerated() {
			if let charAsciiValue = char.asciiValue {
				if setOfPunctuationMarks.contains(Unicode.Scalar(charAsciiValue)) {
					punctuationMarks.append(PunctuationMark(mark: char, index: index))
				}
			}
		}

		var splittedString = self.components(separatedBy: setOfPunctuationMarks)
		splittedString = splittedString.filter { !$0.isEmpty }
		splittedString = splittedString.map { String($0.reversed()) }

		var result = splittedString.joined()

		for punctuationMark in punctuationMarks {
			result.insert(punctuationMark.mark, at: result.index(result.startIndex, offsetBy: punctuationMark.index))
		}

		return result
	}

	func validate() -> Bool {

		let pattern1 = "^\\+79[0-9]{2}[0-9]{7}$"
		let pattern2 = "^\\+7\\s9[0-9]{2}\\s[0-9]{3}\\s[0-9]{2}\\s[0-9]{2}$"
		let pattern3 = "^\\+7\\s\\(9[0-9]{2}\\)\\s[0-9]{3}\\s[0-9]{2}\\s[0-9]{2}$"
		let pattern4 = "^\\+7\\s\\(9[0-9]{2}\\)\\s[0-9]{3}\\-[0-9]{2}\\-[0-9]{2}$"
		let pattern5 = "^7\\(9[0-9]{2}\\)[0-9]{3}[0-9]{2}[0-9]{2}$"
		let pattern6 = "^89[0-9]{2}[0-9]{3}[0-9]{2}[0-9]{2}$"

		let result1 = self.range(of: pattern1, options: .regularExpression, range: nil, locale: nil)
		let result2 = self.range(of: pattern2, options: .regularExpression, range: nil, locale: nil)
		let result3 = self.range(of: pattern3, options: .regularExpression, range: nil, locale: nil)
		let result4 = self.range(of: pattern4, options: .regularExpression, range: nil, locale: nil)
		let result5 = self.range(of: pattern5, options: .regularExpression, range: nil, locale: nil)
		let result6 = self.range(of: pattern6, options: .regularExpression, range: nil, locale: nil)
		if result1 != nil || result2 != nil || result3 != nil || result4 != nil || result5 != nil || result6 != nil   {
			return true
		}
		else {
			return false
		}
	}
}
