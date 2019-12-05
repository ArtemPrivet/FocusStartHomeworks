//
//  HeroesRepository.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/4/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

class HeroesRepository {
	private let netService = NetService()
}

extension HeroesRepository: IHeroRepository {
	func getHeroes(of text: String, completion: @escaping([ResultChar]?) -> Void){
			self.netService.loadHeroes(text) { dataResult in
				switch dataResult {
				case .success(let data):
					completion(data.data.results)
					return
				case .failure(_):
					completion(nil)
					return
				}
			}
	}
}
