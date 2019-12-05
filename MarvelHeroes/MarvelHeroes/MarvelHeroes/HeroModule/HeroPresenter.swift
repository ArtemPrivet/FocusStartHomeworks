//
//  HeroPresenter.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/5/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

class HeroPresenter {

	private var repository: IHeroRepository
	private var router: IHeroRouter

	private var heroes = [ResultChar]()

	init(repository: IHeroRepository, router: IHeroRouter) {
		self.repository = repository
		self.router = router
	}
}

extension HeroPresenter: IHeroPresenter {
	var heroesCount: Int { heroes.count }

	func showDetail(of index: Int) {
		router.showDetail(with: heroes[index])
	}

	func getHero(of index: Int) -> ResultChar {
		heroes[index]
	}

	func getHeroes(of text: String) {
		repository.getHeroes(of: text, completion: { heroList in
			self.heroes = heroList ?? []
			return
		})
	}
}

