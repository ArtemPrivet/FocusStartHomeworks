//
//  AuthorsRepository.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 08.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

typealias AuthorResult = Result<CreatorDataWrapper, ServiceError>

protocol IAuthorsRepository
{
	var dataRepository: IDataRepository { get }

	func getAuthorRequest(fromPastScreen: UrlPath, comicsId: String?, searchResult: String?) -> URL?
	func loadAuthors(fromPastScreen: UrlPath,
					 with id: Int?,
					 searchResult: String?,
					 _ completion: @escaping (AuthorResult) -> Void)
}

final class AuthorsRepository
{
	let dataRepository: IDataRepository

	init(dataRepository: IDataRepository) {
		self.dataRepository = dataRepository
	}
}

extension AuthorsRepository: IAuthorsRepository
{
	func getAuthorRequest(fromPastScreen: UrlPath, comicsId: String?, searchResult: String?) -> URL? {
		let urlString = UrlBuilder()
						.fromPastScreen(pastScreen: fromPastScreen)
						.objectId(comicsId)
						.endPath(object: .authors)
						.build()
		var components = URLComponents(string: urlString)
		components?.queryItems = [
			URLQueryItem(name: "ts", value: Constants.timestamp),
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "orderBy", value: "lastName"),
			URLQueryItem(name: "apikey", value: Constants.publicKey),
			URLQueryItem(name: "hash", value: HashGenerator.generateHash()),
		]
		if let searchText = searchResult {
			components?.queryItems?.append(URLQueryItem(name: "nameStartsWith", value: searchText))
		}
		return components?.url
	}

	func loadAuthors(fromPastScreen: UrlPath,
					 with id: Int?,
					 searchResult: String?,
					 _ completion: @escaping (AuthorResult) -> Void) {
		let objectId = id.map { String($0) }
		guard let url = getAuthorRequest(fromPastScreen: fromPastScreen,
										 comicsId: objectId,
										 searchResult: searchResult) else {
			completion(.failure(ServiceError.dataError(NSError())))
			return }
		dataRepository.fetchData(from: url) { authorResult in
			switch authorResult {
			case .success(let data):
				do {
					let authors = try JSONDecoder().decode(CreatorDataWrapper.self, from: data)
					completion(.success(authors))
				}
				catch {
					completion(.failure(ServiceError.dataError(error)))
					return
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
