//
//  HeroPresenter.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/5/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

final class HeroPresenter
{

	private var repository: IHeroRepository
	private var router: IHeroRouter
	let loadHeroesQueue = DispatchQueue(label: "loadHeroesQueue", qos: .userInteractive, attributes: .concurrent)
	private var heroes = [ResultChar]()

	init(repository: IHeroRepository, router: IHeroRouter) {
		self.repository = repository
		self.router = router
	}
}

extension HeroPresenter: IHeroPresenter
{
	var heroesCount: Int { heroes.count }

	func showDetail(of index: Int) {
		router.showDetail(with: heroes[index])
	}

	func getHero(of index: Int) -> ResultChar {
		heroes[index]
	}

	func getHeroes(of text: String) {
		loadHeroesQueue.async { [weak self] in
			guard let self = self else { return }
			self.repository.getHeroes(of: text, completion: { [weak self] heroList in
				guard let self = self else { return }
				DispatchQueue.main.async {
					self.heroes = heroList ?? []
				}
				return
			})
		}
	}
}
