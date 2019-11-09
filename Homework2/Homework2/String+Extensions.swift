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
	func reversedWords() -> String {
	var newString: String = ""

	if self.contains(" ") {
	let wordsArray = self.components(separatedBy: " ")
	for wordIndex in wordsArray.indices {
	let newWord = String(wordsArray[wordIndex].reversed())
	newString += newWord
	if wordIndex < (wordsArray.count - 1) {
	newString += " "
	}
	}
	}
	else {
	newString = String(self.reversed())
	}

	return newString
	}

	func validate() -> Bool {
	var number = self
	var result = false
	repeat  {
	 if let elementIndex = number.firstIndex(of: " ") {
	number.remove(at: elementIndex)
	}
	if let elementIndex = number.firstIndex(of: " ") {
	number.remove(at: elementIndex)
	}
	if let elementIndex = number.firstIndex(of: "(") {
	number.remove(at: elementIndex)
	}
	if let elementIndex = number.firstIndex(of: ")") {
	number.remove(at: elementIndex)
	}
	if let elementIndex = number.firstIndex(of: "-") {
	number.remove(at: elementIndex)
	}
	} while number.contains(" ") || number.contains("(") || number.contains(")") || number.contains("-")

	if number.hasPrefix("7") || number.hasPrefix("8") {
	number.removeFirst()
	}
	else if number.hasPrefix("+7") {
	number = String(number.dropFirst(2))
	}
	else {
	number.insert("?", at: number.startIndex)
	}
	let code = number.prefix(3)
	if let codeInt = Int(code) {
	if codeInt >= 900 && codeInt <= 999 && number.count == 10 && (Int(number) != nil) {
	result = true
	}
	}
	print(result)
return result
}
}
