//
//  ButtonsStack.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 16.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class ButtonsStack: UIStackView
{
	var cells: [UIButton] = []
	var rows: [UIStackView] = []

	private var currentRow: UIStackView?

	let rowSize: Int
	let rowHeight: CGFloat

	init(rowSize: Int, rowHeight: CGFloat, cellsCount: Int) {
		self.rowSize = rowSize
		self.rowHeight = rowHeight
		super.init(frame: .zero)
		setup()
		for _ in 0..<cellsCount {
			let button = Button()
			addCell(button: button)
		}
		configureOperatorsButtons()
	}

	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		translatesAutoresizingMaskIntoConstraints = false
		spacing = 15
		axis = .vertical
		distribution = .fillEqually
	}

	private func preparedRow() -> UIStackView {
		let row = UIStackView(arrangedSubviews: [])
		row.translatesAutoresizingMaskIntoConstraints = false
		row.axis = .horizontal
		row.spacing = 15
		row.distribution = .fillEqually
		return row
	}

	 private func addCell(button: UIButton) {
		let isFirstCellOfRow = self.cells.count % self.rowSize == 0

		if currentRow == nil || isFirstCellOfRow {
			currentRow = preparedRow()
			if let currentRow = self.currentRow {
				self.addArrangedSubview(currentRow)
				rows.append(currentRow)
			}
		}

		button.translatesAutoresizingMaskIntoConstraints = false

		if UIScreen.main.bounds.width <= 320 {
			//SE and below
			button.heightAnchor.constraint(equalToConstant: self.rowHeight * 0.8).isActive = true
		}
		else {
			button.heightAnchor.constraint(equalToConstant: self.rowHeight).isActive = true
		}

		cells.append(button)

		if let currentRow = self.currentRow {
			currentRow.addArrangedSubview(button)
		}
	}

	private func configureOperatorsButtons() {
		//TODO: configure side buttons operators
		for button in rows {
			if let lastInRow = button.arrangedSubviews.last as? Button {
				lastInRow.backgroundColor = .orange
				lastInRow.setTitleColor(.white, for: .normal)
			}
		}
		//TODO: configure first row operators
		if let firstRow = rows.first {
			for button in firstRow.arrangedSubviews {
				if let button = button as? Button {
					guard button != firstRow.arrangedSubviews.last else { return }
					button.setTitleColor(.darkText, for: .normal)
					button.backgroundColor = .lightGray
				}
			}
		}
	}
}
