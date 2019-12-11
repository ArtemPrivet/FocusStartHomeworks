//
//  ComicsRepository.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/8/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

typealias ComicsResult = Result<[ResultBook], ServiceError>
final class ComicsRepository
{
	private let netService = NetService()
}

extension ComicsRepository: IComicsRepository
{
	func getComics(of heroID: Int, completion: @escaping(ComicsResult) -> Void){
			self.netService.loadComics(heroID) { dataResult in
				switch dataResult {
				case .success(let data):
					completion(.success(data.data.results))
				case .failure(let error):
					completion(.failure(.noData))
					print(error)
				}
			}
	}
}
