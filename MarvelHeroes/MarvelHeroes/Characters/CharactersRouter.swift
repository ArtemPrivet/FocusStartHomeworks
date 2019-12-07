//
//  HeroesRouter.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 01.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation

protocol ICharactersRouter
{
	func showCharacterInfoViewController(character: Character)
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
}
