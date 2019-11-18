//
//  CalculatorScreen.swift
//  Calculator
//
//  Created by Максим Шалашников on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit
import SnapKit

final class CalculatorView: UIView
{
	var buttons: [CalculatorButton] = []
	var label = UILabel()
	private let buttonsCount = 19
	private var buttonSide = 0

	init() {
		super.init(frame: .zero)
		addSubview(label)
		for _ in 0..<buttonsCount {
			let button = CalculatorButton()
			addSubview(button)
			buttons.append(button)
		}
	}
	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		buttonSide = Int((bounds.width - CGFloat(32) - CGFloat(42)) / 4)
		configureButtons()
		configureLabel()
	}
	// MARK: - Default configuration
	private func configureLabel() {
		label.text = "0"
		label.textColor = .white
		label.font = UIFont(name: "FiraSans-Light", size: 94)
		label.textAlignment = .right
		label.numberOfLines = 1
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.5
	}
	private func configureButtons() {
		makeConstraints()
		roundButtons()
		fillButtonsFrame()
		addButtonContent()
	}
	private func roundButtons() {
		buttons.forEach{ button in
			button.layoutIfNeeded()
			button.layer.cornerRadius = button.bounds.height / 2
		}
	}
	private func fillButtonsFrame() {
		for index in 0..<buttonsCount {
			switch index {
			case 2, 6, 10, 14, 18:
				buttons[index].setBackgroundColor(hex: "#ff9500")
			case 15...17:
				buttons[index].setBackgroundColor(hex: "#C4C4C4")
			default:
				buttons[index].setBackgroundColor(hex: "#333333")
			}
		}
	}
	private func addButtonContent() {
		buttons[0].setImage(imageName: "0")
		buttons[1].setText(",")
		buttons[2].setImage(imageName: "Equal")
		buttons[3].setImage(imageName: "1")
		buttons[4].setImage(imageName: "2")
		buttons[5].setImage(imageName: "3")
		buttons[6].setImage(imageName: "Plus")
		buttons[7].setImage(imageName: "4")
		buttons[8].setImage(imageName: "5")
		buttons[9].setImage(imageName: "6")
		buttons[10].setImage(imageName: "Minus")
		buttons[11].setImage(imageName: "7")
		buttons[12].setImage(imageName: "8")
		buttons[13].setImage(imageName: "9")
		buttons[14].setImage(imageName: "Multiply")
		buttons[15].setText("AC")
		buttons[15].setTextColor(UIColor: .black)
		buttons[16].setImage(imageName: "+&-")
		buttons[17].setImage(imageName: "Percent")
		buttons[18].setImage(imageName: "Divide")
	}
	// MARK: - Constraints
	private func makeConstraints() {
		for index in 0..<buttonsCount{
			switch index {
			case 0:
				buttons[index].snp.makeConstraints { maker in
					maker.leading.equalTo(16)
					if #available(iOS 11.0, *) {
						maker.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
					}
					else {
						maker.bottom.equalToSuperview().offset(-16)
					}
					maker.height.greaterThanOrEqualTo(buttonSide)
					maker.width.greaterThanOrEqualTo(buttonSide * 2 + 14)
				}
			case 3, 7, 11, 15:
				buttons[index].snp.makeConstraints { maker in
					maker.leading.equalTo(16)
					maker.bottom.equalTo(buttons[index - 1].snp.top).offset(-15)
					maker.width.height.greaterThanOrEqualTo(buttonSide)
				}
			default:
				buttons[index].snp.makeConstraints { maker in
					maker.leading.equalTo(buttons[index - 1].snp.trailing).offset(14)
					maker.bottom.equalTo(buttons[index - 1].snp.bottom)
					maker.width.height.greaterThanOrEqualTo(buttonSide)
				}
			}
		}
		label.snp.makeConstraints { maker in
			maker.trailing.equalToSuperview().offset(-17)
			maker.leading.equalToSuperview().offset(15)
			maker.bottom.equalTo(buttons[18].snp.top).offset(8)
		}
	}
}
