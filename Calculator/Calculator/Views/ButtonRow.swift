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
	private let countWidth = 4
	private var rowOfButton = [CalculatorButton]()
	let rowStack = UIStackView()

	init() {
		super.init(frame: .zero)
		setUpRowStack()
		addSubview(rowStack)
		makeConstraints()
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
			button.backgroundColor = .green
			rowOfButton.append(button)
			rowStack.addArrangedSubview(button)
//			rowStack.insertArrangedSubview(button, at: index)
		}
		rowStack.axis = .horizontal
		rowStack.distribution = .fill
		rowStack.alignment = .fill
		//		rowStack.spacing = 5
	}

	func makeConstraints() {
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				rowStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
				rowStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
				rowStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
				rowStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1),
				])
		}
		else {
			NSLayoutConstraint.activate([
				rowStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
				rowStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
				rowStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
				rowStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1),
				])
		}
	}
}
