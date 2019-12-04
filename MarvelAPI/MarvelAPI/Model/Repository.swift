//
//  Repository.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

typealias CharactersResult = Result<CharacterDataWrapper, ServiceError>
typealias ImageResult = Result<UIImage, ServiceError>
typealias ComicsResult = Result<ComicDataWrapper, ServiceError>

typealias DataResult = Result<Data, ServiceError>

class Repository {
	private let decoder = JSONDecoder()
	private var dataTask: URLSessionDataTask?
	
	private func fetchData(from url: URL, _ completion: @escaping(DataResult) -> Void) {
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
	
	//load characters
	private func getCharactersRequest(with search: String?) -> URL? {
		var components = URLComponents(string: Urls.baseUrl + Urls.chracterEndpoint)
		components?.queryItems = [
			URLQueryItem(name: "ts", value: Constants.timestamp),
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "orderBy", value: "name"),
			URLQueryItem(name: "apikey", value: Constants.publicKey),
			URLQueryItem(name: "hash", value: HashGenerator.generateHash()),
		]
		if let seatchText = search {
			components?.queryItems?.append(URLQueryItem(name: "nameStartsWith", value: seatchText))
		}
		return components?.url
	}

	func loadCharacters(with search: String?, _ completion: @escaping (CharactersResult) -> Void) {
		guard let url = getCharactersRequest(with: search) else { return }
		fetchData(from: url) { dataResult in
			switch dataResult {
			case .success(let data):
				print(data)
				do {
					let characters = try self.decoder.decode(CharacterDataWrapper.self, from: data)
					completion(.success(characters))
				} catch {
					completion(.failure(ServiceError.dataError(error)))
					return
				}
			case .failure(let error):
				completion(.failure(error))
				print(error.localizedDescription)
			}
		}
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
	
	//load comics
	private func getCharacterComicsRequest(characterId: String) -> URL? { //\(characterId)/
		var components = URLComponents(string: "\(Urls.baseUrl)\(Urls.chracterEndpoint)/\(characterId)/\(Urls.chracterComicsEndpoint)")
		components?.queryItems = [
			URLQueryItem(name: "ts", value: Constants.timestamp),
			URLQueryItem(name: "apikey", value: Constants.publicKey),
			URLQueryItem(name: "hash", value: HashGenerator.generateHash()),
		]
		return components?.url
	}
	
	func loadComics(characterId: Int, _ completion: @escaping (ComicsResult) -> Void) {
		guard let url = getCharacterComicsRequest(characterId: String(characterId)) else { return }
		fetchData(from: url) { comicsResult in
			switch comicsResult {
			case .success(let data):
				do {
					let comic = try self.decoder.decode(ComicDataWrapper.self, from: data)
					completion(.success(comic))
					print("LOADED COMICS")
				} catch {
					completion(.failure(ServiceError.dataError(error)))
					return
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
//	func loadCharactersBySearch(term: String, completion: @escaping ((Result<SearchResult, NSError>) -> Void)) {
//		dataTask?.cancel() //отменяем прошлый запрос если он еще не выполнился
//
//		let urlConponents = URLComponents(string: "https://itunes.apple.com/search/media=music&entity=song&term=\(term)")!
//		let url = urlConponents.url!
//
//
//		dataTask = session.dataTask(with: url) { data, response, error in
//			if let error = error {
//				DispatchQueue.main.async {
//					completion(.failure(error as NSError))
//				}
//				return
//			}
//			if let data = data,
//				let response = response as? HTTPURLResponse, response.statusCode == 200 {
//				do {
//					let object = try JSONDecoder().decode(SearchResult.self, from: data)
//					DispatchQueue.main.async {
//						completion(.success(object))
//					}
//
//				} catch {
//					DispatchQueue.main.async {
//						completion(.failure(error as NSError))
//					}
//				}
//			} else {
//				DispatchQueue.main.async {
//					completion(.failure(NSError()))
//				}
//			}
//		}
//		dataTask?.resume()
//	}


}
