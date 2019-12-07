//
//  HeroesRouter.swift
//  MarvelHeroes
//
//  Created by Саша Руцман on 04/12/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation

protocol IHeroesRouter
{
	func showDetail(with contact: Character)
}

final class HeroesRouter
{
	weak var viewController: HeroesViewController?
	private var factory: ModulesFactory

	init(factory: ModulesFactory) {
		self.factory = factory
	}
}

extension HeroesRouter: IHeroesRouter
{
	func showDetail(with hero: Character) {
		let detailViewController = factory.getDetailCharacterModule(hero: hero)
		viewController?.navigationController?.pushViewController(detailViewController,
																 animated: true)
	}
}
