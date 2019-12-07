//
//  Factory.swift
//  MarvelHeroes
//
//  Created by Саша Руцман on 04/12/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation

final class ModulesFactory
{
	func getHeroModule() -> HeroesViewController {
		let repository = Repository()
		let router = HeroesRouter(factory: self)
		let presenter = HeroesPresenter(repository: repository, router: router)
		let viewController = HeroesViewController(presenter: presenter)
		router.viewController = viewController
		return viewController
	}

	func getDetailCharacterModule(hero: Character) -> DetailedHeroViewController {
		let presenter = DetailedHeroPresenter(character: hero, repository: Repository())
		let viewController = DetailedHeroViewController(presenter: presenter)
		return viewController
	}
}
