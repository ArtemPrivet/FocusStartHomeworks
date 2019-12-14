//
//  Repository.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class Repository: IRepository
{
	private let networkService: INetworkService

	init(networkService: INetworkService) {
		self.networkService = networkService
	}

	func getHeroes(withHeroeName name: String?, _ completion: @escaping (HeroesResult) -> Void) {
		self.networkService.getHeroes(heroeName: name) { heroesResult in
			switch heroesResult {
			case .success(let heroesDataWrapper):
				completion(.success(heroesDataWrapper))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func getImage(urlString: String, _ completion: @escaping (DataOptionalResult) -> Void) {
		self.networkService.getImage(urlString: urlString) { dataResult in
			switch dataResult {
			case .success(let data):
				completion(.success(data))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func getComic(withUrlString urlString: String?, _ completion: @escaping (ComicsResult) -> Void) {
		self.networkService.getComic(withUrlString: urlString) { comicsResult in
			switch comicsResult {
			case .success(let data):
				completion(.success(data))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func getComics(withComicName name: String?, _ completion: @escaping (ComicsResult) -> Void) {
		self.networkService.getComics(withComicName: name) { comicsResult in
			switch comicsResult {
			case .success(let comicsDataWrapper):
				completion(.success(comicsDataWrapper))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func getAuthor(withUrlString urlString: String?, _ completion: @escaping (AuthorsResult) -> Void) {
		self.networkService.getAuthor(withUrlString: urlString) { authorsResult in
			switch authorsResult {
			case .success(let data):
				completion(.success(data))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func getAuthors(withAuthorName name: String?, _ completion: @escaping (AuthorsResult) -> Void) {
		self.networkService.getAuthors(withAuthorName: name) { authorsResult in
			switch authorsResult {
			case .success(let authorsDataWrapper):
				completion(.success(authorsDataWrapper))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
