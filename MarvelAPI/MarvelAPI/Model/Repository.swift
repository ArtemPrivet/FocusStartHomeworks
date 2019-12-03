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
	
	private func getCharactersRequest() -> URL? {
		var components = URLComponents(string: Urls.baseUrl + Urls.chracterEndpoint)
		components?.queryItems = [
			URLQueryItem(name: "ts", value: Constants.timestamp),
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "orderBy", value: "name"),
			URLQueryItem(name: "apikey", value: Constants.publicKey),
			URLQueryItem(name: "hash", value: HashGenerator.generateHash()),
		]
		return components?.url
	}
	
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
	
	func loadCharacters(_ completion: @escaping (CharactersResult) -> Void) {
		guard let url = getCharactersRequest() else { return }
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
	
	func loadCharcterImage(urlString: String, _ completion: @escaping (ImageResult) -> Void) {
		guard let url = URL(string: urlString) else { return }
		fetchData(from: url) { imageResult in
			switch imageResult {
			case .success(let data):
				guard let image = UIImage(data: data) else { return }
				print("ЗАГРУЗИЛАСЬ")
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
//			URLQueryItem(name: "limit", value: "100"),
//			URLQueryItem(name: "characterId", value: characterId),
			URLQueryItem(name: "apikey", value: Constants.publicKey),
			URLQueryItem(name: "hash", value: HashGenerator.generateHash()),
		]
		print(components?.url)
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

}
