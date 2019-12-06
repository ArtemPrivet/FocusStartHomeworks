//
//  NetworkService.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

typealias DataResult = Result<Data, Error>
typealias DataOptionalResult = Result<Data?, Error>
typealias HeroesResult = Result<HeroesDataWrapper, Error>
typealias ComicsResult = Result<ComicsDataWrapper, Error>
typealias AuthorsResult = Result<AuthorsDataWrapper, Error>

final class NetworkService
{
	private var decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}()
}

extension NetworkService: INetworkService
{
	func getHeroes(heroeName: String?, _ completion: @escaping (HeroesResult) -> Void) {
		guard let url = self.createURL(withHeroeName: heroeName) else {
			assertionFailure("Wrong url")
			return
		}
		self.fetchData(fromURL: url) { [weak self] dataResult in
			guard let self = self else { return }
			switch dataResult {
			case .success(let data):
				do {
					let heroesDataWrapper = try self.decoder.decode(HeroesDataWrapper.self, from: data)
					completion(.success(heroesDataWrapper))
				}
				catch {
					completion(.failure(NetworkServiceError.dataError(error)))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func getImage(urlString: String, _ completion: @escaping (DataOptionalResult) -> Void ) {
		guard let url = URL(string: urlString) else {
			assertionFailure("Wrong URL")
			return
		}
		self.fetchData(fromURL: url) { dataResult in
			switch dataResult {
			case .success(let data):
				completion(.success(data))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func getComic(withUrlString urlString: String?, _ completion: @escaping (ComicsResult) -> Void) {
		guard let urlString = urlString, let url = self.createURL(withUrlString: urlString) else {
			assertionFailure("Wrong URL")
			return
		}
		self.fetchData(fromURL: url) { [weak self] dataResult in
			guard let self = self else { return }
			switch dataResult {
			case .success(let data):
				do {
					let comicsDataWrapper = try self.decoder.decode(ComicsDataWrapper.self, from: data)
					completion(.success(comicsDataWrapper))
				}
				catch {
					completion(.failure(NetworkServiceError.dataError(error)))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func getComics(withComicName name: String?, _ completion: @escaping (ComicsResult) -> Void) {
		guard let url = self.createURL(withComicName: name) else {
			assertionFailure("Wrong url")
			return
		}
		self.fetchData(fromURL: url) { [weak self] dataResult in
			guard let self = self else { return }
			switch dataResult {
			case .success(let data):
				do {
					let comicsDataWrapper = try self.decoder.decode(ComicsDataWrapper.self, from: data)
					completion(.success(comicsDataWrapper))
				}
				catch {
					completion(.failure(NetworkServiceError.dataError(error)))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func getAuthor(withUrlString urlString: String?, _ completion: @escaping (AuthorsResult) -> Void) {
		guard let urlString = urlString, let url = self.createURL(withUrlString: urlString) else {
			assertionFailure("Wrong URL")
			return
		}
		self.fetchData(fromURL: url) { [weak self] dataResult in
			guard let self = self else { return }
			switch dataResult {
			case .success(let data):
				do {
					let authorsDataWrapper = try self.decoder.decode(AuthorsDataWrapper.self, from: data)
					completion(.success(authorsDataWrapper))
				}
				catch {
					print(url)
					print(error.localizedDescription)
					completion(.failure(NetworkServiceError.dataError(error)))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func getAuthors(withAuthorName name: String?, _ completion: @escaping (AuthorsResult) -> Void) {
		guard let url = self.createURL(withAuthorName: name) else {
			assertionFailure("Wrong url")
			return
		}
		self.fetchData(fromURL: url) { [weak self] dataResult in
			guard let self = self else { return }
			switch dataResult {
			case .success(let data):
				do {
					let authorsDataWrapper = try self.decoder.decode(AuthorsDataWrapper.self, from: data)
					completion(.success(authorsDataWrapper))
				}
				catch {
					completion(.failure(NetworkServiceError.dataError(error)))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}

extension NetworkService
{
	private func createURL(withHeroeName heroeName: String?) -> URL? {

		var urlComponents = URLComponents()
		urlComponents.scheme = URLConstants.scheme
		urlComponents.host = URLConstants.marvelURL
		urlComponents.path = URLConstants.charactersURL

		let timestamp = String(Int(Date().timeIntervalSince1970))
		guard let hash = HashFunctions.MD5(timestamp + APIKeys.privateKey + APIKeys.publicKey) else { return nil }

		if let heroeName = heroeName {
			urlComponents.queryItems = [
				URLQueryItem(name: "nameStartsWith", value: heroeName),
				URLQueryItem(name: "ts", value: timestamp),
				URLQueryItem(name: "apikey", value: APIKeys.publicKey),
				URLQueryItem(name: "hash", value: hash),
			]
		}
		else {
			urlComponents.queryItems = [
				URLQueryItem(name: "ts", value: timestamp),
				URLQueryItem(name: "apikey", value: APIKeys.publicKey),
				URLQueryItem(name: "hash", value: hash),
				URLQueryItem(name: "limit", value: "100"),
			]
		}

		guard let url = urlComponents.url else {
			assertionFailure("Wrong URL")
			return nil
		}
		return url
	}

	private func createURL(withComicName comicName: String?) -> URL? {
		var urlComponents = URLComponents()
		urlComponents.scheme = URLConstants.scheme
		urlComponents.host = URLConstants.marvelURL
		urlComponents.path = URLConstants.comicsURL

		let timestamp = String(Int(Date().timeIntervalSince1970))
		guard let hash = HashFunctions.MD5(timestamp + APIKeys.privateKey + APIKeys.publicKey) else { return nil }

		if let comicName = comicName {
			urlComponents.queryItems = [
				URLQueryItem(name: "titleStartsWith", value: comicName),
				URLQueryItem(name: "ts", value: timestamp),
				URLQueryItem(name: "apikey", value: APIKeys.publicKey),
				URLQueryItem(name: "hash", value: hash),
			]
		}
		else {
			urlComponents.queryItems = [
				URLQueryItem(name: "ts", value: timestamp),
				URLQueryItem(name: "apikey", value: APIKeys.publicKey),
				URLQueryItem(name: "hash", value: hash),
				URLQueryItem(name: "limit", value: "100"),
			]
		}

		guard let url = urlComponents.url else {
			assertionFailure("Wrong URL")
			return nil
		}
		return url
	}

	private func createURL(withAuthorName authorName: String?) -> URL? {
		var urlComponents = URLComponents()
		urlComponents.scheme = URLConstants.scheme
		urlComponents.host = URLConstants.marvelURL
		urlComponents.path = URLConstants.authorsURL

		let timestamp = String(Int(Date().timeIntervalSince1970))
		guard let hash = HashFunctions.MD5(timestamp + APIKeys.privateKey + APIKeys.publicKey) else { return nil }

		if let authorName = authorName {
			urlComponents.queryItems = [
				URLQueryItem(name: "nameStartsWith", value: authorName),
				URLQueryItem(name: "ts", value: timestamp),
				URLQueryItem(name: "apikey", value: APIKeys.publicKey),
				URLQueryItem(name: "hash", value: hash),
			]
		}
		else {
			urlComponents.queryItems = [
				URLQueryItem(name: "ts", value: timestamp),
				URLQueryItem(name: "apikey", value: APIKeys.publicKey),
				URLQueryItem(name: "hash", value: hash),
				URLQueryItem(name: "limit", value: "100"),
			]
		}

		guard let url = urlComponents.url else {
			assertionFailure("Wrong URL")
			return nil
		}
		return url
	}

	private func createURL(withUrlString urlString: String) -> URL? {
		var urlComponents = URLComponents(string: urlString)

		let timestamp = String(Int(Date().timeIntervalSince1970))
		guard let hash = HashFunctions.MD5(timestamp + APIKeys.privateKey + APIKeys.publicKey) else { return nil }
		urlComponents?.queryItems = [
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "apikey", value: APIKeys.publicKey),
			URLQueryItem(name: "hash", value: hash),
		]
		guard let url = urlComponents?.url else {
			assertionFailure("Wrong URL")
			return nil
		}
		return url
	}

	private func fetchData(fromURL url: URL, _ completion: @escaping (DataResult) -> Void) {

		let session = URLSession.shared

		let dataTask = session.dataTask(with: url) { data, response, error in
			if let sessionError = error {
				completion(.failure(NetworkServiceError.sessionError(sessionError)))
			}

			if let data = data, let response = response as? HTTPURLResponse {
				switch response.statusCode {
				case 400 ..< 500:
					completion(.failure(NetworkServiceError.clientError(response.statusCode)))
				case 500 ..< 600:
					completion(.failure(NetworkServiceError.serverError(response.statusCode)))
				default:
					break
				}
				completion(.success(data))
			}
		}
		dataTask.resume()
	}
}
