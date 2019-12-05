//
//  Repository.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

typealias CharactersResult = Result<CharacterDataWrapper, ServiceError>
typealias ComicsResult = Result<ComicDataWrapper, ServiceError>
typealias AuthorResult = Result<CreatorDataWrapper, ServiceError>

typealias ImageResult = Result<UIImage, ServiceError>
typealias DataResult = Result<Data, ServiceError>

final class Repository
{
	private let decoder = JSONDecoder()
	private var dataTask: URLSessionDataTask?

	private func fetchData(from url: URL, _ completion: @escaping(DataResult) -> Void) {
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let newError = error {
				completion(.failure(.sessionError(newError)))
				return
			}
			if let data = data, let response = response as? HTTPURLResponse {
				if 400..<500 ~= response.statusCode {
					completion(.failure(ServiceError.statusCode(response.statusCode)))
					return
				}
				completion(.success(data))
			}
		}
		task.resume()
	}

	func loadImage(urlString: String, _ completion: @escaping (ImageResult) -> Void) {
		guard let url = URL(string: urlString) else { return }
		fetchData(from: url) { imageResult in
			switch imageResult {
			case .success(let data):
				guard let image = UIImage(data: data) else { return }
				completion(.success(image))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	//load characters
	private func getCharactersRequest(comicsId: String?, searchResult: String?) -> URL? {
		let urlString: String
		if let comicsId = comicsId {
			urlString = "\(Urls.baseUrl)\(Urls.comicsEndpoint)/\(comicsId)/\(Urls.chracterEndpoint)"
		}
		else {
			urlString = "\(Urls.baseUrl)/\(Urls.chracterEndpoint)"
		}

		var components = URLComponents(string: urlString)
		components?.queryItems = [
			URLQueryItem(name: "ts", value: Constants.timestamp),
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "orderBy", value: "name"),
			URLQueryItem(name: "apikey", value: Constants.publicKey),
			URLQueryItem(name: "hash", value: HashGenerator.generateHash()),
		]
		if let seatchText = searchResult {
			components?.queryItems?.append(URLQueryItem(name: "nameStartsWith", value: seatchText))
		}
		return components?.url
	}

	func loadCharacters(with id: Int?, searchResult: String?, _ completion: @escaping (CharactersResult) -> Void) {
		var objectId: String?
		if let id = id {
			objectId = String(id)
		}
		guard let url = getCharactersRequest(comicsId: objectId, searchResult: searchResult) else { return }
		fetchData(from: url) { dataResult in
			switch dataResult {
			case .success(let data):
				do {
					let characters = try self.decoder.decode(CharacterDataWrapper.self, from: data)
					completion(.success(characters))
				}
				catch {
					completion(.failure(ServiceError.dataError(error)))
					return
				}
			case .failure(let error):
				completion(.failure(error))
				print(error.localizedDescription)
			}
		}
	}

	//load comics
	private func getComicsRequest(fromPastScreen: String?, characterId: String?, searchResult: String?) -> URL? {
		let urlString: String
		if let charId = characterId, fromPastScreen == PastScreen.authors {
			urlString = "\(Urls.baseUrl)\(Urls.authorEndpoint)/\(charId)/\(Urls.comicsEndpoint)"
		}
		else if let charId = characterId, fromPastScreen == PastScreen.characters {
			urlString = "\(Urls.baseUrl)\(Urls.chracterEndpoint)/\(charId)/\(Urls.comicsEndpoint)"
		}
		else {
			urlString = "\(Urls.baseUrl)/\(Urls.comicsEndpoint)"
		}

		var components = URLComponents(string: urlString)
		components?.queryItems = [
			URLQueryItem(name: "ts", value: Constants.timestamp),
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "orderBy", value: "title"),
			URLQueryItem(name: "apikey", value: Constants.publicKey),
			URLQueryItem(name: "hash", value: HashGenerator.generateHash()),
		]
		if let seatchText = searchResult {
			components?.queryItems?.append(URLQueryItem(name: "titleStartsWith", value: seatchText))
		}
		return components?.url
	}

	func loadComics(fromPastScreen: String?,
					with id: Int?,
					searchResult: String?,
					_ completion: @escaping (ComicsResult) -> Void) {
		var objectId: String?
		if let id = id {
			objectId = String(id)
		}
		guard let url = getComicsRequest(fromPastScreen: fromPastScreen,
										 characterId: objectId,
										 searchResult: searchResult) else { return }
		fetchData(from: url) { comicsResult in
			switch comicsResult {
			case .success(let data):
				do {
					let comics = try self.decoder.decode(ComicDataWrapper.self, from: data)
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

	//load authors
	private func getAuthorRequest(comicsId: String?, searchResult: String?) -> URL? {
		let urlString: String
		if let comicsId = comicsId {
			urlString = "\(Urls.baseUrl)\(Urls.authorEndpoint)/\(comicsId)/\(Urls.comicsEndpoint)" //FIXIT
		}
		else {
			urlString = "\(Urls.baseUrl)/\(Urls.authorEndpoint)"
		}

		var components = URLComponents(string: urlString)
		components?.queryItems = [
			URLQueryItem(name: "ts", value: Constants.timestamp),
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "orderBy", value: "lastName"),
			URLQueryItem(name: "apikey", value: Constants.publicKey),
			URLQueryItem(name: "hash", value: HashGenerator.generateHash()),
		]
		if let seatchText = searchResult {
			components?.queryItems?.append(URLQueryItem(name: "nameStartsWith", value: seatchText))
		}
		return components?.url
	}

	func loadAuthors(with id: Int?, searchResult: String?, _ completion: @escaping (AuthorResult) -> Void) {
		var objectId: String?
		if let id = id {
			objectId = String(id)
		}
		guard let url = getAuthorRequest(comicsId: objectId, searchResult: searchResult) else { return }
		fetchData(from: url) { authorResult in
			switch authorResult {
			case .success(let data):
				do {
					let authors = try self.decoder.decode(CreatorDataWrapper.self, from: data)
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
