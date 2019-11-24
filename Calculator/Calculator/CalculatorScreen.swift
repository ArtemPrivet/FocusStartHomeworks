//
//  CalculatorButtons.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 17/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorScreen: UIView
{
	weak var delegate: IButton?
	weak var delegateToPR: IDisplayInfo?

	var pendingResult = PendingResult()

	private let countWidth = 4
	private let countHeight = 5
	private var count: Int {
		return countWidth * countHeight
	}

	let display = CalculatorDisplay()
	let buttonsStack = ButtonsStack()

	init() {
		super.init(frame: .zero)
		addSubview(display)
		addSubview(buttonsStack)
		makeConstraints()
		translatesAutoresizingMaskIntoConstraints = false
		buttonsStack.delegate = self
		self.delegate = pendingResult
		pendingResult.delegateToScreen = self
//		pendingResult.delegate = display
	}
	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	func makeConstraints() {
		translatesAutoresizingMaskIntoConstraints = false

		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				display.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
				display.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 79),
				display.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -17),
				display.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1 / 6),
				])
			NSLayoutConstraint.activate([
				buttonsStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
				buttonsStack.topAnchor.constraint(equalTo: display.safeAreaLayoutGuide.bottomAnchor, constant: 15),
				buttonsStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -17),
				buttonsStack.heightAnchor.constraint(equalTo: buttonsStack.safeAreaLayoutGuide.widthAnchor, multiplier: 5 / 4),
				])
		}
		else {
			NSLayoutConstraint.activate([
				display.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
				display.topAnchor.constraint(equalTo: self.topAnchor, constant: 99),
				display.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17),
				display.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1 / 6),
				])
			NSLayoutConstraint.activate([
				buttonsStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
				buttonsStack.topAnchor.constraint(equalTo: display.bottomAnchor, constant: 15),
				buttonsStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17),
				buttonsStack.heightAnchor.constraint(equalTo: buttonsStack.widthAnchor, multiplier: 5 / 4),
				])
		}
	}
}

extension CalculatorScreen: IButton
{
	func allClear() {
		print("Screen AC")
		delegate?.allClear()
	}

	func clear() {
		print("Screen C")
		delegate?.clear()
	}

	func plusMinus() {
		print("Screen +/-")
		delegate?.plusMinus()
	}

	func percent() {
		print("Screen +/-")
		delegate?.percent()
	}

	func operatorPressed(is oper: String) {
		print("Screen operator")
		delegate?.operatorPressed(is: oper)
	}

	func digit(inputText: String) {
		print("Screen inputText: \(inputText)")
		delegate?.digit(inputText: inputText)
	}

	func comma() {
		print("Screen +/-")
		delegate?.comma()
	}

	func equalTo() {
		print("Screen =")
		delegate?.equalTo()
	}

	func getButtonDetails(identifier: Int) {
		print("Screen got info from: \(identifier)")
		delegate?.getButtonDetails(identifier: identifier)
	}
}

extension CalculatorScreen: IPendingResult
{
	func showResult(result: String) {
		print("Screen: IPendingResult info: \(result)")
		display.setText(result)
		pendingResult.displayingNow(nowText: display.text)
	}
}
