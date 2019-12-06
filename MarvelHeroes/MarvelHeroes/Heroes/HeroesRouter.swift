//
//  HeroesRouter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class HeroesRouter
{
	weak var heroesView: HeroesView?
	private var factory: Factory

	init(factory: Factory) {
		self.factory = factory
	}
}

extension HeroesRouter: IHeroesRouter
{
	func pushModuleWithHeroeInfo(heroe: Heroe) {
		let heroeDetailsVC = self.factory.createHeroeDetailsModule(withHeroe: heroe)
		self.heroesView?.navigationController?.pushViewController(heroeDetailsVC,
																  animated: true)
	}
}
