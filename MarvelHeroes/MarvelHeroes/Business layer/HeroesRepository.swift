//
//  HeroesRepository.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/4/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

typealias CharactersResult = Result<[ResultChar]?, ServiceError>
final class HeroesRepository
{
	private let netService = NetService()
}

extension HeroesRepository: IHeroRepository
{
	func getHeroes(of text: String, completion: @escaping(CharactersResult) -> Void){
			self.netService.loadHeroes(text) { dataResult in
				switch dataResult {
				case .success(let data):
					completion(.success(data.data.results))
					return
				case .failure(let error):
					completion(.failure(.noData))
					print(error)
					return
				}
			}
	}
}
