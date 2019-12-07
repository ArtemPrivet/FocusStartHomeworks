//
//  Factory.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/5/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

final class ModulesFactory
{

	func getDetailModule(hero: ResultChar) -> DetailViewController {
		let presenter = DetailPresenter(hero: hero)
		let viewController = DetailViewController(presenter: presenter)
		return viewController
	}

	func getHeroModule() -> HeroViewController {
		let repository = HeroesRepository()
		let router = HeroRouter(factory: self)
		let presenter = HeroPresenter(repository: repository, router: router)
		let viewController = HeroViewController(presenter: presenter)
		router.viewController = viewController
		presenter.heroVC = viewController
		return viewController
	}
}
