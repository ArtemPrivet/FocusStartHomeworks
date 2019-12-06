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
	weak var charactersView: CharactersViewController?
	private let builder: IBuilder

	init(builder: IBuilder, view: CharactersViewController) {
		self.builder = builder
		charactersView = view
	}
	func showCharacterInfoViewController(character: Character) {
		let view = builder.createCharacterInfoViewController(character: character)
		charactersView?.navigationController?.pushViewController(view, animated: true)
	}
}
