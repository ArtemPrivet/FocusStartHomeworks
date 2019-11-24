//
//  ButtonsStack.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 18/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class ButtonsStack: UIStackView
{
	weak var delegate: IButton?
	private let countHeight = 5
	private var arrayOfRows = [ButtonRow]()

	init() {
		super.init(frame: .zero)
		setUpButtonStack()
		translatesAutoresizingMaskIntoConstraints = false
	}
	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setUpButtonStack() {
		for _ in 0..<countHeight {
			let row = ButtonRow()
			row.delegate = self
			self.addArrangedSubview(row)
		}
		self.axis = .vertical
		self.alignment = .fill
		self.distribution = .fillEqually
		self.spacing = 15
	}
}

extension ButtonsStack: IButton
{
	func allClear() {
		print("Stack AC")
		delegate?.allClear()
	}

	func clear() {
		print("Stack C")
		delegate?.clear()
	}

	func plusMinus() {
		print("Stack +/-")
		delegate?.plusMinus()
	}

	func percent() {
		print("Stack +/-")
		delegate?.percent()
	}

	func operatorPressed(is oper: String) {
		print("Stack operator")
		delegate?.operatorPressed(is: oper)
	}

	func digit(inputText: String) {
		print("Stack inputText: \(inputText)")
		delegate?.digit(inputText: inputText)
	}

	func comma() {
		print("Stack +/-")
		delegate?.comma()
	}

	func equalTo() {
		print("Stack =")
		delegate?.equalTo()
	}

	func getButtonDetails(identifier: Int) {
		print("Stack got info from: \(identifier)")
		delegate?.getButtonDetails(identifier: identifier)
	}
}
