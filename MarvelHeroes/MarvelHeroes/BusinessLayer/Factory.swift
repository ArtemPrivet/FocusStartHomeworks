//
//  Factory.swift
//  MarvelHeroes
//
//  Created by MacBook Air on 04.12.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import Foundation

final class Factory
{
	func getCharacterViewController() -> CharacterViewController {
		let jsonService = NetworkService()
		let repository = CharacterRepository(jsonService: jsonService)
		let router = CharacterRouter(factory: self)
		let presenter = CharacterPresenter(repository: repository, router: router)
		let viewController = CharacterViewController(presenter: presenter)
		router.viewController = viewController
		presenter.view = viewController
		return viewController
	}

	func getDetailViewController(character: Character) -> DetailViewController {
		let jsonService = NetworkService()
		let repository = CharacterRepository(jsonService: jsonService)
		let presenter = DetailPresenter(repository: repository, character: character)
		let viewController = DetailViewController(presenter: presenter)
		return viewController
	}
}
