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
		for _ in 0..<countHeight {
			let row = ButtonRow()
			arrayOfRows.append(row)
			mainStack.addArrangedSubview(row)
		}
		mainStack.axis = .vertical
		mainStack.distribution = .fill
		mainStack.alignment = .fill
		mainStack.spacing = 5
		addSubview(mainStack)
		translatesAutoresizingMaskIntoConstraints = false
	}
	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
