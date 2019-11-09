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
		var reversedWordsArr = [String]()
		let wordsArr = self.split(separator: " ")
		_ = wordsArr.map {
			var lettersArr = [Character]()
			var reversedWord = ""
			for letter in $0 {
				lettersArr.append(letter)
			}
			lettersArr.reverse()
			_ = lettersArr.map {
				reversedWord += String($0)
			}
			reversedWordsArr.append(reversedWord)
		}
		return reversedWordsArr.joined(separator: " ")
	}

	func validate() -> Bool {
		let regex = "^((8|\\+7|7)[\\-]?)(\\(?9\\d{2}\\)?[\\-]?)(\\d{3}[\\-]?)(\\d{2}[\\-]?)(\\d{2}[\\-]?)$"
		let phoneTest = NSPredicate(format: "SELF MATCHES %@", regex)
		return phoneTest.evaluate(with: self.split(separator: " ").joined(separator: ""))
		// ((8|\\+7|7)[\\- ]?) 8 или +7 или 7, "-" опциональный элемент
		// (\\(?9 "(" опциональный элемент, 9 обязательный
		// \\d{2} сопоставление, чтобы было 2 цифры
		// \\)? ")" - опциональный элемент
		// [\\- ]?) - "-" опциональный элемент
		// (\\d{3}[\\- ]?) - сопоставление, чтобы было 3 цифры, после которых "-" опциональный элемент
	}
}
