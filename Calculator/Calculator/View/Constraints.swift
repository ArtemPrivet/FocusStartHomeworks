//
//  Constraints.swift
//  Calculator
//
//  Created by MacBook Air on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import Foundation

extension Screen
{

	func makeConstraints() {

		for (index, button) in button.buttonArray.enumerated() {
			switch index {
			case 0:
				button.snp.makeConstraints { make in
				make.width.greaterThanOrEqualTo(164).priority(999)
				make.height.greaterThanOrEqualTo(75)
				}
			default:
				button.snp.makeConstraints { make in
				make.width.greaterThanOrEqualTo(75).priority(999)
				make.height.equalTo(button.snp.width)
				}
			}
		}

		allButtonsStackView.snp.makeConstraints { make in
			if #available(iOS 11.0, *) {
				make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).inset(16)
				make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(16)
				make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(17).priority(999)
			}
			else {
				make.leading.bottom.equalToSuperview().inset(16)
				make.trailing.equalToSuperview().inset(17)
			}
		}

		bottomStackView.snp.makeConstraints { make in
			make.height.equalTo(secondStackView.snp.height)
		}

		windowLabel.snp.makeConstraints { make in
			if #available(iOS 11.0, *) {
				make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).inset(15)
				make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(17).priority(999)
			}
			else {
				make.leading.equalToSuperview().inset(15)
				make.trailing.equalToSuperview().inset(17).priority(999)
			}
			make.bottom.equalTo(allButtonsStackView.snp.top).inset(-8)
		}
	}
}
