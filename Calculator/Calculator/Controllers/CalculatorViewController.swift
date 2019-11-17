//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Artem Orlov on 12/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit
import SnapKit

final class CalculatorViewController: UIViewController
{

	private let countOfRows = 5
	private let countOfColumns = 4

	private var resultView: ResultView = {
		ResultView()
	}()
	private lazy var buttonsAreaView: ButtonsAreaView = {
		let buttonsArea = ButtonsAreaView(buttons: self.createButtons(), rows: countOfRows, columns: countOfColumns)
		return buttonsArea
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		self.view.addSubview(resultView)
		self.view.addSubview(buttonsAreaView)
		setConstraints()
	}

	private func setConstraints() {
		var selfView: UILayoutGuide
		if #available(iOS 11.0, *) {
			selfView = self.view.safeAreaLayoutGuide
		}
		else {
			selfView = self.view.layoutMarginsGuide
		}
		resultView.snp.makeConstraints { maker in
			maker.leading.equalTo(selfView).offset(15)
			//maker.top.equalTo(selfView).offset(99)
			maker.trailing.equalTo(selfView).offset(-17)
			maker.height.equalTo(113)
		}
		buttonsAreaView.snp.makeConstraints { maker in
			maker.leading.trailing.equalToSuperview()
			maker.bottom.equalTo(selfView)
			maker.top.equalTo(resultView.snp.bottom).offset(8)
			maker.height.equalTo(buttonsAreaView.snp.width).multipliedBy(CGFloat(countOfRows) / CGFloat(countOfColumns))
		}
	}

	private func createButtons() -> [[ButtonView?]] {
		// swiftlint:disable multiline_literal_brackets
		// swiftlint:disable trailing_comma
		[
			[ButtonView(type: .operators("AC")),
			 ButtonView(type: .operators("+/-")),
			 ButtonView(type: .operators("%")),
			 ButtonView(type: .operators("÷"))],
			[ButtonView(type: .operators("7")),
			 ButtonView(type: .operators("8")),
			 ButtonView(type: .operators("9")),
			 ButtonView(type: .operators("x"))],
			[ButtonView(type: .operators("4")),
			 ButtonView(type: .operators("5")),
			 ButtonView(type: .operators("6")),
			 ButtonView(type: .operators("-"))],
			[ButtonView(type: .operators("1")),
			 ButtonView(type: .operators("2")),
			 ButtonView(type: .operators("3")),
			 ButtonView(type: .operators("+"))],
			[ButtonView(type: .operators("0")),
			 nil,
			 ButtonView(type: .operators(",")),
			 ButtonView(type: .operators("="))]
		]
		// swiftlint:enable multiline_literal_brackets
		// swiftlint:enable trailing_comma
//		var buttons =
//			[[ButtonView?]](repeatElement([ButtonView?](repeatElement(nil, count: countOfColumns)), count: countOfRows))
//		for row in 0..<countOfRows {
//			for column in 0..<countOfColumns {
//				buttons[row][column] = ButtonView(title: "\(row + column)")
//			}
//		}
//		return buttons
	}
}
