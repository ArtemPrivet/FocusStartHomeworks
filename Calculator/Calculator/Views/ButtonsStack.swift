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
	private let countHeight = 5
	private var arrayOfRows = [ButtonRow]()
	private let mainStack = UIStackView()

	init() {
		super.init(frame: .zero)
		setUpButtonStack()
		addSubview(mainStack)
//		makeConstraints()
		translatesAutoresizingMaskIntoConstraints = false
	}
	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setUpButtonStack() {
		for _ in 0..<countHeight {
			let row = ButtonRow()
			arrayOfRows.append(row)
			mainStack.addArrangedSubview(row)
		}
		mainStack.axis = .vertical
		mainStack.distribution = .fill
		mainStack.alignment = .fill
		//		mainStack.spacing = 5
	}

	func makeConstraints() {
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				mainStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
				mainStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
				mainStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
				mainStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1),
				])
		}
		else {
			NSLayoutConstraint.activate([
				mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
				mainStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
				mainStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
				mainStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1),
				])
		}
	}
}
