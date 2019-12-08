//
//  CharactersRepository.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 08.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

typealias CharactersResult = Result<CharacterDataWrapper, ServiceError>

protocol ICharactersRepository
{
	var dataRepository: IDataRepository { get }

	func getCharactersRequest(fromPastScree: UrlPath, comicsId: String?, searchResult: String?) -> URL?
	func loadCharacters(fromPastScree: UrlPath,
						with id: Int?,
						searchResult: String?,
						_ completion: @escaping (CharactersResult) -> Void)}

final class CharactersRepository
{
	let dataRepository: IDataRepository

	init(dataRepository: IDataRepository) {
		self.dataRepository = dataRepository
	}
}

extension CharactersRepository: ICharactersRepository
{
	func getCharactersRequest(fromPastScree: UrlPath, comicsId: String?, searchResult: String?) -> URL? {
		let urlString = UrlBuilder()
			.fromPastScreen(pastScreen: fromPastScree)
			.objectId(comicsId)
			.endPath(object: .characters)
			.build()

		var components = URLComponents(string: urlString)
		components?.queryItems = [
			URLQueryItem(name: "ts", value: Constants.timestamp),
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "orderBy", value: "name"),
			URLQueryItem(name: "apikey", value: Constants.publicKey),
			URLQueryItem(name: "hash", value: HashGenerator.generateHash()),
		]
		if let searchText = searchResult {
			components?.queryItems?.append(URLQueryItem(name: "nameStartsWith", value: searchText))
		}
		return components?.url
	}

	func loadCharacters(fromPastScree: UrlPath,
						with id: Int?,
						searchResult: String?,
						_ completion: @escaping (CharactersResult) -> Void) {
		let objectId = id.map { String($0) }
		guard let url = getCharactersRequest(fromPastScree: fromPastScree,
											 comicsId: objectId,
											 searchResult: searchResult) else {
			completion(.failure(ServiceError.dataError(NSError())))
			return }
		dataRepository.fetchData(from: url) { dataResult in
			switch dataResult {
			case .success(let data):
				do {
					let characters = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
					completion(.success(characters))
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
