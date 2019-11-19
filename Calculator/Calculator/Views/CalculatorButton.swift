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
	private let button = UIButton()
	var identifier: Int = 0
	var group: Group = .numbers
	private static var indentifierFactory = 0

	private static func getUniqueIdentifier() -> Int {
		indentifierFactory += 1
		return indentifierFactory
	}

	init() {
		super.init(frame: .zero)
		self.identifier = CalculatorButton.getUniqueIdentifier()
		getGroup()
		button.backgroundColor = .purple
		addSubview(button)
		translatesAutoresizingMaskIntoConstraints = false
		print(identifier)
		makeConstraints()
	}
	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
//		self.layer.cornerRadius = self.bounds.height / 2
	}

	func setText(_ text: String) {
		button.setTitle(text, for: .normal)
		button.tintColor = .white
	}

	enum Group
	{
		case numbers, operators, others
	}

	private func getGroup() {
		switch self.identifier {
		case 1...3: self.group = .others
		case 4, 8, 12, 16, 20: self.group = .operators
		case 5...7, 9...11, 13...15, 16...19: self.group = .numbers
		default: break
		}
	}

	func makeConstraints() {
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				button.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
				button.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
				button.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
				button.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1),
				])
		}
		else {
			NSLayoutConstraint.activate([
				button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
				button.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
				button.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
				button.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1),
				])
		}
	}
}
