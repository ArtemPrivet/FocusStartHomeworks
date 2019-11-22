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
	let screenLabel = ScreenLabel()
	let buttonsStack = ButtonsStack(rowSize: 4, rowHeight: 75, cellsCount: 19)

	init() {
		super.init(frame: .zero)
		initialSetup()
		createSubviews()
	}

	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func initialSetup() {
		backgroundColor = .black
	}

	private func createSubviews() {
		addSubview(screenLabel)
		addSubview(buttonsStack)
		resizeLastRow()
		setConstraints()
	}

	private func resizeLastRow() {
		if let lastRow = buttonsStack.rows.last {
			if let zero = lastRow.arrangedSubviews.first as? Button {
				zero.isRounded = false
				zero.widthAnchor.constraint(
					greaterThanOrEqualTo: buttonsStack.widthAnchor,
					multiplier: 0.45,
					constant: 0
				).isActive = true
				lastRow.distribution = .fillProportionally
				lastRow.alignment = .fill
			}
		}
	}

	private func setConstraints() {
		translatesAutoresizingMaskIntoConstraints = false

		screenLabel.setContentHuggingPriority(
			UILayoutPriority(1),
			for: .vertical
		)
		screenLabel.setContentCompressionResistancePriority(
			UILayoutPriority(749),
			for: .vertical)

			NSLayoutConstraint.activate([
			screenLabel.topAnchor.constraint(greaterThanOrEqualTo: self.layoutMarginsGuide.topAnchor, constant: 20),
			screenLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
			screenLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),

			buttonsStack.topAnchor.constraint(equalTo: screenLabel.bottomAnchor),
			buttonsStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
			buttonsStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
			buttonsStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -20),
			])
	}
}
