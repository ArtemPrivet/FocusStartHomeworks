//
//  NetworkService.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import Foundation

enum ServiceError: Error {
	case cannotMakeURL
	case noData
	case statusCodeError(Int)
	case sessionError(Error)
	case decodingError(Error)
	case cannotCreateImageFromData
}

typealias CharacterDataWrapperResult = Result<Data, ServiceError>
typealias ComicDataWrapperResult = Result<[Comic], ServiceError>

protocol IMarvelAPIService {
	func loadCharacters(name: String, _ completion: @escaping (CharacterDataWrapperResult) -> Void)
	func loadComics(_ completion: @escaping (ComicDataWrapperResult) -> Void)
}

final class MarvelAPIService {

	private let apiKey = "385b86e3ae22c2b0f3e18cc61579e4ea"
	private let privateApiKey = "a01fbf7404225c0f9e07d1886ce7a9a1ee2e758e"
	private var timestamp: TimeInterval { Date().timeIntervalSince1970 }
	private var hash: String { MD5(String(Int(timestamp)) + privateApiKey + apiKey) }

	private lazy var requiredQueryItems = [
		URLQueryItem(name: "apikey", value: apiKey),
		URLQueryItem(name: "ts", value: String(Int(timestamp))),
		URLQueryItem(name: "hash", value: hash)
	]

	private typealias DataReult = Result<Data, ServiceError>

	private let urlSession = URLSession.shared

	private enum URLS: String {
		case characters, comics

		private static let base = URL(string: "https://gateway.marvel.com:443/v1/public")!

		var url: URL? {
			Self.base.appendingPathComponent(self.rawValue)
		}
	}

	private enum Parameters: String {
		case name, nameStartsWith, modifiedSince, orderBy
	}

	private enum OrderBy: String {
		case name, modified
	}

	private func fetchData(
		from url: URL?,
		parameters: [URLQueryItem],
		_ completion: @escaping (DataReult) -> Void) {

		guard let url = url else {
			completion(.failure(.cannotMakeURL))
			return
		}

		var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
		urlComponents?.queryItems = parameters + requiredQueryItems

		guard let urlWithComponents = urlComponents?.url else {
			completion(.failure(.cannotMakeURL))
			return
		}

		let dataTask = urlSession.dataTask(with: urlWithComponents) { data, response, error in

			if let error = error {
				completion(.failure(.sessionError(error)))
				return
			}

			guard
				let httpResponse = response as? HTTPURLResponse,
				(200..<300) ~= httpResponse.statusCode else {
					completion(.failure(.statusCodeError((response as? HTTPURLResponse)?.statusCode ?? 500)))
					return
			}

			guard let data = data else {
				completion(.failure(.noData))
				return
			}
			completion(.success(data))
			return
		}
		dataTask.resume()
	}
}

extension MarvelAPIService: IMarvelAPIService {
	func loadCharacters(name: String, _ completion: @escaping (CharacterDataWrapperResult) -> Void) {
		let parameters = [
			URLQueryItem(name: Parameters.orderBy.rawValue, value: OrderBy.name.rawValue),
			URLQueryItem(name: Parameters.nameStartsWith.rawValue, value: name)
		]
		fetchData(from: URLS.characters.url, parameters: parameters) { result in
			completion(result)
		}
	}

	func loadComics(_ completion: @escaping (ComicDataWrapperResult) -> Void) {
		fetchData(from: URLS.comics.url, parameters: []) { result in
//			switch result {
//			case .success(let data):
//				do {
//					let response = try self.decoder.decode(ComicDataWrapper.self, from: data)
//					completion(.success((response.data.results)))
//				} catch {
//					completion(.failure(.decodingError(error)))
//				}
//			case .failure(let error):
//				completion(.failure(error))
//			}
		}
	}
}
