//
//  CharacterInfoRouter.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 05.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import UIKit
protocol ICharacterInfoRouter
{
	func showAlert(title: String?, message: String, style: UIAlertController.Style)
}
final class CharacterInfoRouter: ICharacterInfoRouter
{
	private let builder: IBuilder
	weak var view: CharacterInfoViewController?

	init(builder: ControllerBuilder) {
		self.builder = builder
	}
	func showAlert(title: String?, message: String, style: UIAlertController.Style) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: style)
		let actionOK = UIAlertAction(title: "Ok", style: .default)
		alert.addAction(actionOK)
		view?.navigationController?.pushViewController(alert, animated: true)
	}
}
