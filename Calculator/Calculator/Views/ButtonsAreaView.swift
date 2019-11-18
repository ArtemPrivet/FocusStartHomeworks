//
//  ButtonsAreaView.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 16.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class ButtonsAreaView: UIView
{
	// MARK: Private properties
	private let buttons: [[ButtonView?]]
	private let grid: (rows: Int, columns: Int)
	private let offset: CGFloat

	private var countOfCells: Int {
		grid.rows * grid.columns
	}

	private var estimateHeight: CGFloat = 0

	// MARK: Initialization
	init(buttons: [[ButtonView?]],
		 grid: (rows: Int, columns: Int),
		 offset: CGFloat,
		 backgroundColor: UIColor) {
		self.buttons = buttons
		self.grid = grid
		self.offset = offset
		super.init(frame: .zero)
		setup(backgroundColor: backgroundColor)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Life cycle
	override func layoutSubviews() {
		setFrames()
	}

	// MARK: Private methods
	private func setup(backgroundColor: UIColor) {
		self.backgroundColor = backgroundColor
		buttons.flatMap { $0.compactMap { $0 } }.forEach { addSubview($0) }
	}

	private func setFrames() {
		let width = bounds.width / CGFloat(grid.columns)
		let height = bounds.height / CGFloat(grid.rows)

		for numberOfRows in 0..<grid.rows {
			var previousButton: ButtonView?

			for numberOfColumns in 0..<grid.columns {

				guard let button = buttons[numberOfRows][numberOfColumns] else {

					guard let previousButton = previousButton else { continue }

					let size = CGSize(width: previousButton.frame.size.width * 2 + offset,
									  height: previousButton.frame.size.height)
					previousButton.frame = calculateButtonFrame(origin: previousButton.frame.origin, size: size)

					continue
				}

				previousButton = button
				button.frame = calculateButtonFrame(origin: bounds.origin,
													offset: offset,
													horizontalMultiple: CGFloat(numberOfColumns),
													verticalMultiple: CGFloat(numberOfRows),
													size: CGSize(width: width, height: height))
			}
		}
	}

	private func calculateButtonFrame(origin: CGPoint,
									  offset: CGFloat = 0,
									  horizontalMultiple: CGFloat = 0,
									  verticalMultiple: CGFloat = 0,
									  size: CGSize) -> CGRect {
		CGRect(x: origin.x + size.width * horizontalMultiple + offset / 2,
			   y: origin.y + size.height * verticalMultiple + offset / 2,
			   width: size.width - offset,
			   height: size.height - offset)
	}
}
