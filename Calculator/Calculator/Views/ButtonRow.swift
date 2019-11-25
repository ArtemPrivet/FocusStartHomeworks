//
//  ButtonRow.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 18/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class ButtonRow: UIStackView
{
	weak var delegate: IButton?

	private let countWidth = 4
	private var isTyping = false

	init() {
		super.init(frame: .zero)
		setUpRowStack()
		translatesAutoresizingMaskIntoConstraints = false
	}

	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	func setUpRowStack() {
		for _ in 0..<countWidth {
			let button = CalculatorButton()
			button.delegate = self
			switch button.identifier {
			case 20: break
			case 17...19: self.addArrangedSubview(button)
			self.distribution = .equalSpacing
			if button.identifier == 17 {
				button.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 2, constant: -7.5).isActive = true
				button.contentHorizontalAlignment = .left
				button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
			}
			else {
				button.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 4, constant: -12).isActive = true
				}
			default:
			self.distribution = .fillEqually
			button.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
			self.addArrangedSubview(button)
			}
		}
		self.spacing = 15
		self.axis = .horizontal
		self.alignment = .fill
	}
}

extension ButtonRow: IButton
{
	func allClear() {
		delegate?.allClear()
	}

	func clear() {
		delegate?.clear()
	}

	func plusMinus() {
		delegate?.plusMinus()
	}

	func percent() {
		delegate?.percent()
	}

	func operatorPressed(is oper: String) {
		delegate?.operatorPressed(is: oper)
	}

	func digit(inputText: String) {
		delegate?.digit(inputText: inputText)
	}

	func comma() {
		delegate?.comma()
	}

	func equalTo() {
		delegate?.equalTo()
	}

	func getButtonDetails(identifier: Int) {
		delegate?.getButtonDetails(identifier: identifier)
	}
}
