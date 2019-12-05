//
//  HeroesRepository.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/4/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

class HeroesRepository {
	let netService = NetService()
}

extension HeroesRepository: IHeroRepository {
	func getHeroes(_ text: String) -> [ResultChar] {
		var heroes = [ResultChar]()
			self.netService.loadHeroes(text) { dataResult in
				switch dataResult {
				case .success(let data):
					heroes = data.data.results
				case .failure(let error):
					print(error)
					heroes = []
				}
			}
		return heroes
	}
}
