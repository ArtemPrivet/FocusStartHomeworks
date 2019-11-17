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
	var resultLabel = UILabel(frame: .zero)
	var buttons = [ButtonView]()
	var rows = [RowButtonsStackView]()

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
		addSubview(resultLabel)
		resultLabel.backgroundColor = .white //DELETE
		createNumbersButtons()
		createOtherButtons()
		setRowsButtons()
		setButtonsColor()
		makeConstraints()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - setButtons
	func createNumbersButtons() {
		for index in (0...9).reversed() {
			let button = ButtonView(frame: .zero)
			button.tag = index
			button.setTitle(String(button.tag), for: .normal)
			switch index {
			case 0:
				fifthRowButtons.insertArrangedSubview(button, at: 0)
			case 1...3:
				fourthRowButtons.insertArrangedSubview(button, at: 0)
			case 4...6:
				thirdRowButtons.insertArrangedSubview(button, at: 0)
			case 7...9:
				secondRowButtons.insertArrangedSubview(button, at: 0)
			default: break
			}
		}
	}

	private func decomposeOperationButtons(_ index: Int) {
		let button = ButtonView(frame: .zero)
		button.tag = index
		button.setTitle(String(button.tag), for: .normal)
		switch index {
		case 10...11:
			fifthRowButtons.insertArrangedSubview(button, at: 1)
		case 12:
			fourthRowButtons.addArrangedSubview(button)
		case 13:
			thirdRowButtons.addArrangedSubview(button)
		case 14:
			secondRowButtons.addArrangedSubview(button)
		default:
			firstRowButtons.addArrangedSubview(button)
		}
	}

	func createOtherButtons() {
		for index in (10..<19).reversed() {
			switch index {
			case OperationButtons.floating.rawValue:
				decomposeOperationButtons(index)
			case OperationButtons.floating.rawValue:
				decomposeOperationButtons(index)
			case OperationButtons.equal.rawValue:
				decomposeOperationButtons(index)
			case OperationButtons.plus.rawValue:
				decomposeOperationButtons(index)
			case OperationButtons.minus.rawValue:
				decomposeOperationButtons(index)
			case OperationButtons.multiply.rawValue:
				decomposeOperationButtons(index)
			case OperationButtons.divide.rawValue:
				decomposeOperationButtons(index)
			case OperationButtons.percent.rawValue:
				decomposeOperationButtons(index)
			case OperationButtons.negativeSwitch.rawValue:
				decomposeOperationButtons(index)
			case OperationButtons.ac.rawValue:
				decomposeOperationButtons(index)
			default: break
			}
		}
	}

	private func setOperationButtonsTitle(_ button: ButtonView) {
		switch button.tag {
		case 11:
			button.setTitle("=", for: .normal)
		case 12:
			button.setTitle("+", for: .normal)
		case 13:
			button.setTitle("-", for: .normal)
		case 14:
			button.setTitle("x", for: .normal)
		case 15:
			button.setTitle("\u{00f7}", for: .normal)
		case 16:
			button.setTitle("%", for: .normal)
		case 17:
			button.setTitle("+/-", for: .normal)
		case 18:
			button.setTitle("AC", for: .normal)
		default: break
		}
	}

	func setButtonsColor() {
		for button in buttons {
			switch button.tag {
			case 0...10:
				button.backgroundColor = Colors.colorDarkGray
				button.setTitleColor(Colors.colorWhite, for: .normal)
			case 11...15:
				button.backgroundColor = Colors.colorOrange
				button.setTitleColor(Colors.colorWhite, for: .normal)
				setOperationButtonsTitle(button)
			case 16...18:
				button.backgroundColor = Colors.colorGray
				button.setTitleColor(Colors.colorBlack, for: .normal)
				setOperationButtonsTitle(button)
			default: break
			}
		}
	}

	func setRowsButtons() {
		fifthRowButtons.alignment = .fill
		fifthRowButtons.distribution = .fill
		print(firstRowButtons.arrangedSubviews.count)

		buttonsStackView = ButtonsStackView(arrangedSubviews: [
			firstRowButtons,
			secondRowButtons,
			thirdRowButtons,
			fourthRowButtons,
			fifthRowButtons,
			])
		print(buttonsStackView.arrangedSubviews.count)
		for rowButtonsStack in buttonsStackView.arrangedSubviews {
			guard let rowButtonsStack = rowButtonsStack as? RowButtonsStackView else { return }
			print(rowButtonsStack.arrangedSubviews.count)
			rows.append(rowButtonsStack)
			for button in rowButtonsStack.arrangedSubviews {
				guard let button = button as? ButtonView else { return }
				buttons.append(button)
			}
		}
	}

	func makeConstraints() {
		for button in buttons where button.tag != 0 {
			button.snp.makeConstraints { make in
				make.width.equalTo(button.snp.height).multipliedBy(1)
			}
		}

		fifthRowButtons.snp.makeConstraints { make in
			print(buttons.count)
			var equalBut = ButtonView(frame: .zero)
			for view in buttons where view.tag == 0 {
				equalBut = view
			}
			make.width.equalTo(equalBut.snp.width).multipliedBy(2).offset(14)
		}

		buttonsStackView.snp.makeConstraints { make in
			addSubview(buttonsStackView) //FIX
			make.leading.equalToSuperview().offset(16)
			make.trailing.equalToSuperview().offset(-17)
			make.bottomMargin.equalToSuperview().offset(-16)
		}

		resultLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(15)
			make.trailing.equalToSuperview().offset(-17)
			make.bottom.equalTo(buttonsStackView.snp.top).offset(-8)
			make.height.equalTo(113)
		}
	}
}
