//
//  ComicsRepository.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 08.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

typealias ComicsResult = Result<ComicDataWrapper, ServiceError>

protocol IComicsRepository
{
	func getComicsRequest(fromPastScreen: UrlPath, objectId: String?, searchResult: String?) -> URL?
	func loadComics(fromPastScreen: UrlPath,
					with id: Int?,
					searchResult: String?,
					_ completion: @escaping (ComicsResult) -> Void)
	func fetchData(from url: URL, _ completion: @escaping(DataResult) -> Void)
	func loadImage(urlString: String, _ completion: @escaping (ImageResult) -> Void)
}

final class ComicsRepository: DataRepository
{
}

extension ComicsRepository: IComicsRepository
{
	func getComicsRequest(fromPastScreen: UrlPath, objectId: String?, searchResult: String?) -> URL? {
		let urlString = UrlBuilder()
			.objectId(objectId)
			.fromPastScreen(pastScreen: fromPastScreen)
			.endPath(object: .comics)
			.build()
		var components = URLComponents(string: urlString)
		components?.queryItems = [
			URLQueryItem(name: "ts", value: Constants.timestamp),
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "orderBy", value: "-title"),
			URLQueryItem(name: "apikey", value: Constants.publicKey),
			URLQueryItem(name: "hash", value: HashGenerator.generateHash()),
		]
		if let searchText = searchResult {
			components?.queryItems?.append(URLQueryItem(name: "titleStartsWith", value: searchText))
		}
		return components?.url
	}

	func loadComics(fromPastScreen: UrlPath,
					with id: Int?,
					searchResult: String?,
					_ completion: @escaping (ComicsResult) -> Void) {
		let objectId = id.map { String($0) }
		guard let url = getComicsRequest(fromPastScreen: fromPastScreen,
										 objectId: objectId,
										 searchResult: searchResult) else { return }
		fetchData(from: url) { comicsResult in
			switch comicsResult {
			case .success(let data):
				do {
					let comics = try JSONDecoder().decode(ComicDataWrapper.self, from: data)
					completion(.success(comics))
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
