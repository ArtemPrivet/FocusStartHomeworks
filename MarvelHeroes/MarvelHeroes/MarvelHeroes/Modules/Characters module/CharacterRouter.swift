//
//  CharacterRouter.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

protocol ICharactersRouter {

}

class CharactersRouter: ICharactersRouter {

	weak var view: ICharacterListViewController?

	private var factory: ModulesFactory

	init(factory: ModulesFactory) {
		self.factory = factory
	}
}
