//
//  NetworkService.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import Foundation

enum ServiceError: Error
{
	case cannotMakeURL
	case noData
	case statusCodeError(Int)
	case sessionError(Error)
	case decodingError(Error)
	case cannotCreateImageFromData
}

typealias CharacterDataWrapperResult = Result<Data, ServiceError>
typealias ComicDataWrapperResult = Result<Data, ServiceError>
typealias CreatorDataWrapperResult = Result<Data, ServiceError>

typealias CharacterDataWrapperCompletion = (CharacterDataWrapperResult) -> Void
typealias ComicDataWrapperCompletion = (ComicDataWrapperResult) -> Void
typealias CreatorDataWrapperCompletion = (CreatorDataWrapperResult) -> Void

// MARK: - Protocol IMarvelAPIService
protocol IMarvelAPIService
{
	func loadCharacters(name: String, _ completion: @escaping CharacterDataWrapperCompletion)
	func loadComics(title: String, _ completion: @escaping ComicDataWrapperCompletion)
	func loadCreators(lastName: String, _ completion: @escaping CreatorDataWrapperCompletion)

	func loadComics(characterID: String, _ completion: @escaping ComicDataWrapperCompletion)
	func loadComics(creatorID: String, _ completion: @escaping ComicDataWrapperCompletion)
	func loadCreators(comicID: String, _ completion: @escaping CreatorDataWrapperCompletion)
}

// MARK: - Class
final class MarvelAPIService
{

	private typealias DataReult = Result<Data, ServiceError>

	private enum URLS: String
	{
		case characters, comics, creators

		private static let base = URL(string: "https://gateway.marvel.com:443/v1/public")

		var url: URL? {
			Self.base?.appendingPathComponent(self.rawValue)
		}
	}

	private enum Parameters: String
	{
		case nameStartsWith, modifiedSince, orderBy, characterID, titleStartsWith, lastNameStartsWith, apikey, hash, limit
		case timeStamp = "ts"
	}

	private enum OrderBy: String
	{
		case name, modified, focDate, lastName, firstName, middleName, suffix
	}

	// MARK: ...Private properties
	private let apiKey = "385b86e3ae22c2b0f3e18cc61579e4ea"
	private let privateApiKey = "a01fbf7404225c0f9e07d1886ce7a9a1ee2e758e"
	private var timestamp: TimeInterval { Date().timeIntervalSince1970 }
	private var hash: String { MD5(String(Int(timestamp)) + privateApiKey + apiKey) }

	private lazy var requiredQueryItems = [
		URLQueryItem(name: Parameters.apikey.rawValue, value: apiKey),
		URLQueryItem(name: Parameters.timeStamp.rawValue, value: String(Int(timestamp))),
		URLQueryItem(name: Parameters.hash.rawValue, value: hash),
		URLQueryItem(name: Parameters.limit.rawValue, value: String(100)),
	]

	private let urlSession = URLSession.shared

	// MARK: ...Private methods
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

// MARK: - IMarvelAPIService
extension MarvelAPIService: IMarvelAPIService
{

	// MARK: ...Load item by name

	/// Load characters by name
	/// - Parameters:
	///   - name: start with name
	///   - completion: returns data
	func loadCharacters(name: String, _ completion: @escaping CharacterDataWrapperCompletion) {
		let parameters = [
			URLQueryItem(name: Parameters.orderBy.rawValue,
						 value: OrderBy.name.rawValue),
			URLQueryItem(name: Parameters.nameStartsWith.rawValue,
						 value: name),
		]
		fetchData(from: URLS.characters.url, parameters: parameters) { result in
			completion(result)
		}
	}

	/// Load comics by title
	/// - Parameters:
	///   - title: start with title
	///   - completion: returns data
	func loadComics(title: String, _ completion: @escaping ComicDataWrapperCompletion) {
		let parameters = [
			URLQueryItem(name: Parameters.orderBy.rawValue,
						 value: OrderBy.focDate.rawValue),
			URLQueryItem(name: Parameters.titleStartsWith.rawValue,
						 value: title),
		]
		fetchData(from: URLS.comics.url, parameters: parameters) { result in
			completion(result)
		}
	}

	/// Load creators by last name
	/// - Parameters:
	///   - lastName: start with last name
	///   - completion: returns data
	func loadCreators(lastName: String, _ completion: @escaping CreatorDataWrapperCompletion) {
		let parameters = [
			URLQueryItem(name: Parameters.orderBy.rawValue,
						 value: OrderBy.lastName.rawValue),
			URLQueryItem(name: Parameters.lastNameStartsWith.rawValue,
						 value: lastName),
		]
		fetchData(from: URLS.creators.url, parameters: parameters) { result in
			completion(result)
		}
	}

	// MARK: ...Load item by id
	/// Load comics by character ID
	/// - Parameters:
	///   - characterID: ID of character
	///   - completion: result data
	func loadComics(characterID: String, _ completion: @escaping ComicDataWrapperCompletion) {
		let parameters = [
			URLQueryItem(name: Parameters.orderBy.rawValue,
						 value: OrderBy.focDate.rawValue),
		]
		let url = URLS.characters.url?
			.appendingPathComponent(characterID)
			.appendingPathComponent(URLS.comics.rawValue)
		fetchData(from: url, parameters: parameters) { result in
			completion(result)
		}
	}

	/// Load comics by creator ID
	/// - Parameters:
	///   - creatorID: ID of creator
	///   - completion: result data
	func loadComics(creatorID: String, _ completion: @escaping ComicDataWrapperCompletion) {
		let parameters = [
			URLQueryItem(name: Parameters.orderBy.rawValue,
						 value: OrderBy.focDate.rawValue),
		]
		let url = URLS.creators.url?
			.appendingPathComponent(creatorID)
			.appendingPathComponent(URLS.comics.rawValue)
		fetchData(from: url, parameters: parameters) { result in
			completion(result)
		}
	}

	/// Load creators by comic ID
	/// - Parameters:
	///   - comicID: ID of comic
	///   - completion: result data
	func loadCreators(comicID: String, _ completion: @escaping CreatorDataWrapperCompletion) {
		let parameters = [
			URLQueryItem(name: Parameters.orderBy.rawValue,
						 value: OrderBy.lastName.rawValue),
		]
		let url = URLS.comics.url?
			.appendingPathComponent(comicID)
			.appendingPathComponent(URLS.creators.rawValue)
		fetchData(from: url, parameters: parameters) { result in
			completion(result)
		}
	}
}
