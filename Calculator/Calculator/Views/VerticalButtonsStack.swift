//
//  VerticalButtonsStack.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 16.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class VerticalButtonsStack: UIStackView
{
	var cells: [Button] = []
	var rows: [UIStackView] = []

	private let cellsCount: Int
	private var currentRow: UIStackView?

	private let rowPadding: CGFloat = 15

	private let rowSize: Int
	private let rowHeight: CGFloat

	init(rowSize: Int, rowHeight: CGFloat, cellsCount: Int) {
		self.rowSize = rowSize
		self.rowHeight = rowHeight
		self.cellsCount = cellsCount
		super.init(frame: .zero)
		initialSetup()
		fillGridWithCells()
		configureOperatorsButtonsBackground()
		setButtonTitles()
	}

	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func initialSetup() {
		axis = .vertical
		spacing = rowPadding
		distribution = .fillEqually
	}

	private func preparedHorizontalRow() -> UIStackView {
		let row = UIStackView(arrangedSubviews: [])
		row.axis = .horizontal
		row.spacing = rowPadding
		row.distribution = .fillEqually
		return row
	}

	private func addCellToRow(button: Button) {
		let isFirstCellOfRow = self.cells.count % self.rowSize == 0

		if currentRow == nil || isFirstCellOfRow {
			currentRow = preparedHorizontalRow()
			if let currentRow = self.currentRow {
				self.addArrangedSubview(currentRow)
				rows.append(currentRow)
			}
		}

		cells.append(button)

		if let currentRow = self.currentRow {
			currentRow.addArrangedSubview(button)
		}
	}

	private func fillGridWithCells() {
		for _ in 0..<cellsCount {
			let button = Button()
			addCellToRow(button: button)
		}
	}

	// MARK: Configure Buttons View
	private func configureOperatorsButtonsBackground() {
		//configure side buttons view
		for stack in rows {
			if let lastInRow = stack.arrangedSubviews.last as? Button {
				lastInRow.backgroundColor = .systemOrange
				lastInRow.setTitleColor(.white, for: .normal)
			}
		}

		//configure first row buttons view
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

	private func setButtonTitles() {
		let titles = [
			Sign.allClear, Sign.changeSign, Sign.percent, Sign.divide,
			"7", "8", "9", Sign.multiply,
			"4", "5", "6", Sign.minus,
			"1", "2", "3", Sign.plus,
			Sign.zero, Sign.decimalSeparator, Sign.equals,
		]

		for (index, button) in cells.enumerated() {
			button.setTitle(titles[index], for: .normal)
			switch button.currentTitle {
			case Sign.divide, Sign.minus, Sign.multiply, Sign.plus, Sign.equals:
				button.titleLabel?.font = UIFont.systemFont(ofSize: 38, weight: .regular)
			default:
				break
			}
		}
	}
}
