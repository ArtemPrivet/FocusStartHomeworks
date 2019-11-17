//
//  CalcalatorView.swift
//  Calculator
//
//  Created by Kirill Fedorov on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalcalatorView: UIView
{

	var buttons = [ButtonView]()
	var rows = [RowButtonsStackView]()

	let zeroNumberButton = ButtonView(frame: .zero)
	let floatNumberButton = ButtonView(frame: .zero)
	let equalButton = ButtonView(frame: .zero)

	let oneNumberButton = ButtonView(frame: .zero)
	let twoNumberButton = ButtonView(frame: .zero)
	let threeNumberButton = ButtonView(frame: .zero)
	let plusButton = ButtonView(frame: .zero)

	let fourNumberButton = ButtonView(frame: .zero)
	let fiveNumberButton = ButtonView(frame: .zero)
	let sixNumberButton = ButtonView(frame: .zero)
	let minusButton = ButtonView(frame: .zero)

	let sevenNumberButton = ButtonView(frame: .zero)
	let eightNumberButton = ButtonView(frame: .zero)
	let nineNumberButton = ButtonView(frame: .zero)
	let multiplyButton = ButtonView(frame: .zero)

	let acButton = ButtonView(frame: .zero)
	let negativeSwitchButton = ButtonView(frame: .zero)
	let percentButton = ButtonView(frame: .zero)
	let divideButton = ButtonView(frame: .zero)

	var firstRowButtons = RowButtonsStackView(frame: .zero)
	var secondRowButtons = RowButtonsStackView(frame: .zero)
	var thirdRowButtons = RowButtonsStackView(frame: .zero)
	var fourthRowButtons = RowButtonsStackView(frame: .zero)
	var fifthRowButtons = RowButtonsStackView(frame: .zero)

	var buttonsStackView = ButtonsStackView(frame: .zero)

	init() {
		super.init(frame: .zero)
		backgroundColor = .white
		addSubview(buttonsStackView)
		equalButton.tag = 1
		setRowsButtons()
		makeConstraints()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - setButtons
	func setRowsButtons() {
		firstRowButtons = RowButtonsStackView(arrangedSubviews: [
			acButton,
			negativeSwitchButton,
			percentButton,
			divideButton,
			])
		secondRowButtons = RowButtonsStackView(arrangedSubviews: [
			sevenNumberButton,
			eightNumberButton,
			nineNumberButton,
			multiplyButton,
			])
		thirdRowButtons = RowButtonsStackView(arrangedSubviews: [
			fourNumberButton,
			fiveNumberButton,
			sixNumberButton,
			minusButton,
			])
		fourthRowButtons = RowButtonsStackView(arrangedSubviews: [
			oneNumberButton,
			twoNumberButton,
			threeNumberButton,
			plusButton,
			])
		fifthRowButtons = RowButtonsStackView(arrangedSubviews: [
			equalButton,
			floatNumberButton,
			zeroNumberButton,
			])
		fifthRowButtons.alignment = .fill
		fifthRowButtons.distribution = .fill

		buttonsStackView = ButtonsStackView(arrangedSubviews: [
			firstRowButtons,
			secondRowButtons,
			thirdRowButtons,
			fourthRowButtons,
			fifthRowButtons,
			])

		for rowButtonsStack in buttonsStackView.arrangedSubviews {
			guard let rowButtonsStack = rowButtonsStack as? RowButtonsStackView else { return }
			rows.append(rowButtonsStack)
			for button in rowButtonsStack.arrangedSubviews {
				guard let button = button as? ButtonView else { return }
				buttons.append(button)
			}
		}
	}

	func makeConstraints() {
		for button in buttons where button.tag != 1 {
			button.snp.makeConstraints { make in
				make.width.equalTo(button.snp.height).multipliedBy(1)
			}
		}

		fifthRowButtons.snp.makeConstraints { make in
			make.width.equalTo(equalButton.snp.width).multipliedBy(2).offset(14)
		}

		buttonsStackView.snp.makeConstraints { make in
			addSubview(buttonsStackView) //FIX
			make.leading.equalToSuperview().offset(16)
			make.trailing.equalToSuperview().offset(-17)
			make.bottom.equalToSuperview().offset(-16)
		}
	}
}
