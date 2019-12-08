//
//  ComicsRepository.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/8/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

import UIKit

final class ComicsRepository
{
	private let netService = NetService()
}

extension ComicsRepository: IComicsrepository
{
	func getComics(of heroID: Int, completion: @escaping([ResultBook]?) -> Void){
			self.netService.loadComics(heroID) { dataResult in
				switch dataResult {
				case .success(let data):
					completion(data.data.results)
					return
				case .failure:
					completion(nil)
					return
				}
			}
	}
}
