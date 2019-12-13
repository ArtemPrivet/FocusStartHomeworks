//
//  HeroesRouter.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 01.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import UIKit

protocol ICharactersRouter
{
	func showCharacterInfoViewController(character: Character)
	func showAlert(title: String?, message: String, style: UIAlertController.Style)
}
final class CharactersRouter: ICharactersRouter
{
	weak var view: CharactersViewController?
	private let builder: IBuilder

	init(builder: IBuilder) {
		self.builder = builder
	}
	func showCharacterInfoViewController(character: Character) {
		let nextView = builder.createCharacterInfoViewController(character: character)
		view?.navigationController?.pushViewController(nextView, animated: true)
	}
	func showAlert(title: String?, message: String, style: UIAlertController.Style) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: style)
		let actionOK = UIAlertAction(title: "Ok", style: .default)
		alert.addAction(actionOK)
		view?.present(alert, animated: true, completion: nil)
	}
}
