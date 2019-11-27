//
//  CalculatorView.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 16.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorView: UIView
{
	let displayLabel = DisplayLabel()
	let buttonsStack = VerticalButtonsStack(rowSize: 4, rowHeight: 75, cellsCount: 19)

	init() {
		super.init(frame: .zero)
		initialSetup()
		addSubviews()
	}

	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func initialSetup() {
		backgroundColor = .black
	}

	private func addSubviews() {
		addSubview(displayLabel)
		addSubview(buttonsStack)
		resizeLastRow()
		setConstraints()
	}

	private func resizeLastRow() {
		if let lastRow = buttonsStack.rows.last {
				lastRow.distribution = .fill
				lastRow.alignment = .fill
		}
	}

	private func setConstraints() {
		buttonsStack.cells.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			if $0.currentTitle != Sign.zero {
					$0.widthAnchor.constraint(equalTo: $0.heightAnchor).isActive = true
			}
		}
		translatesAutoresizingMaskIntoConstraints = false
		buttonsStack.translatesAutoresizingMaskIntoConstraints = false
		displayLabel.translatesAutoresizingMaskIntoConstraints = false

		buttonsStack.rows.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		NSLayoutConstraint.activate([
			displayLabel.topAnchor.constraint(greaterThanOrEqualTo: self.layoutMarginsGuide.topAnchor, constant: 20),
			displayLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
			displayLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),

			buttonsStack.topAnchor.constraint(equalTo: displayLabel.bottomAnchor),
			buttonsStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
			buttonsStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
			buttonsStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -20),
		])
	}
}
