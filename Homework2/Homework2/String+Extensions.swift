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

extension String
{

	mutating func reversedWords() -> String {
		let stringg = self
		//let reversedString = String(string.reversed())
		let result = stringg.split(separator: " ").map { String($0.reversed()) }.joined(separator: " ")

		return String(result)
	}

	func validate() -> Bool {
		let stringg = self
		let result = stringg.first
		if result == "+" || result == "7" || result == "8" {

			return true
		}
		return false
	}
}
