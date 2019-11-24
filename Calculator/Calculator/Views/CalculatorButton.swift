//
//  CalculatorButton.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 17/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorButton: UIButton
{
	weak var delegate: IButton?
	var identifier: Int = 0
	private var group: Group = .numbers

	private static var indentifierFactory = 0

	private static func getUniqueIdentifier() -> Int {
		indentifierFactory += 1
		return indentifierFactory
	}

	init() {
		super.init(frame: .zero)
		self.identifier = CalculatorButton.getUniqueIdentifier()
		getGroup()
		getColor()
		getLabel()
		addActionToButton()
		translatesAutoresizingMaskIntoConstraints = false
	}
	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = self.bounds.height / 2
	}

	func setText(_ text: String) {
		self.setTitle(text, for: .normal)
		if self.group == .others {
			self.setTitleColor(.black, for: [])
			self.titleLabel?.font = UIFont(name: "FiraSans-Light", size: 30)
		}
		else if self.group == .operators {
			self.titleLabel?.font = UIFont(name: "FiraSans-Light", size: 50)
		}
		else {
			self.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 35)
		}
	}

	enum Group
	{
		case numbers, operators, others
	}

	private func getGroup() {
		switch self.identifier {
		case 1...3: self.group = .others
		case 4, 8, 12, 16, 19: self.group = .operators
		case 5...7, 9...11, 13...15, 16...18: self.group = .numbers
		default: break
		}
	}

	private func getColor() {
		switch self.group {
		case .numbers: self.backgroundColor = .darkGray
		case .operators: self.backgroundColor = .orange
		case .others: self.backgroundColor = .lightGray
		}
	}

	private func addActionToButton() {
			self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
	}

	@objc func buttonClicked(sender: UIButton) {
		self.faded()
		guard let text = (sender.subviews.last as? UILabel)?.text
			else {
				return
		}
		guard let delegate = self.delegate else {
			return
		}
		delegate.getButtonDetails(identifier: self.identifier)
		switch text {
		case "AC": delegate.allClear()
		case "C": delegate.clear()
		case "⁺⁄₋": delegate.plusMinus()
		case "%": delegate.percent()
		case "÷", "×", "+", "-": delegate.operatorPressed(is: text)
		case "=": delegate.equalTo()
		case ",": delegate.comma()
		case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9": delegate.digit(inputText: text)
		default:
			break
		}
	}

	private func getLabel() {
		switch self.identifier {
		case 1: self.setText("AC")
		case 2: self.setText("⁺⁄₋")
		case 3: self.setText("%")
		case 4: self.setText("÷")
		case 5: self.setText("7")
		case 6: self.setText("8")
		case 7: self.setText("9")
		case 8: self.setText("×")
		case 9: self.setText("4")
		case 10: self.setText("5")
		case 11: self.setText("6")
		case 12: self.setText("-")
		case 13: self.setText("1")
		case 14: self.setText("2")
		case 15: self.setText("3")
		case 16: self.setText("+")
		case 17: self.setText("0")
		case 18: self.setText(",")
		case 19: self.setText("=")
		default: break
		}
	}
}
