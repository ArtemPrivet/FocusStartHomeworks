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

	private let buttons: [[ButtonView?]]
	private let countOfRows: Int
	private let countOfColumns: Int

	private var estimateHeight: CGFloat = 0

	private var countOfCells: Int {
		countOfRows * countOfColumns
	}

	init(buttons: [[ButtonView?]], rows: Int, columns: Int, backgroundColor: UIColor) {
		self.buttons = buttons
		self.countOfRows = rows
		self.countOfColumns = columns
		super.init(frame: .zero)
		setup(backgroundColor: backgroundColor)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		setFrames()
	}

	private func setup(backgroundColor: UIColor) {
		self.backgroundColor = backgroundColor
		buttons.flatMap { $0.compactMap { $0 } }.forEach { addSubview($0) }
	}

	private func setFrames() {
		let offset: CGFloat = 14
		let width = bounds.width / CGFloat(countOfColumns)
		let height = bounds.height / CGFloat(countOfRows)

		for numberOfRows in 0..<countOfRows {
			var previousButton: ButtonView?
			for numberOfColumns in 0..<countOfColumns {
				guard let button = buttons[numberOfRows][numberOfColumns] else {
					guard let previousButton = previousButton else { continue }
					previousButton.frame =
						calculateButtonFrame(origin: previousButton.frame.origin,
											 size: CGSize(width: previousButton.frame.size.width * 2 + offset, height: previousButton.frame.size.height))
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
