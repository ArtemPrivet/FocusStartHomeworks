//
//  JsonService.swift
//  MarvelHeroes
//
//  Created by MacBook Air on 02.12.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit

typealias DataResult = Result<Data, ServiceError>
typealias CharacterResult = Result<[Character], ServiceError>
typealias ImageResult = Result<UIImage, ServiceError>

protocol INetworkService
{
	func loadCharacter(name: String, _ completion: @escaping(CharacterResult) -> Void)
	func loadImage(imageUrl: String, _ completion: @escaping (ImageResult) -> Void)
}

final class NetworkService
{
	private let baseUrl = URL(string: "https://gateway.marvel.com/v1/public/characters?")
	private let publicKey = "7e95fcb24f48e6f5664a04ab87cb1083"
	private let privateKey = "bdd47bde424e1c094f2bf0be737288689439827a"
	private let timestamp = "\(Date().timeIntervalSince1970)"

	private lazy var hash = "\(timestamp)\(privateKey)\(publicKey)".md5

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
}

extension NetworkService: INetworkService
{
	func loadCharacter(name: String, _ completion: @escaping (CharacterResult) -> Void) {

		let query = [
		URLQueryItem(name: "nameStartsWith", value: name),
		URLQueryItem(name: "limit", value: "100"),
		URLQueryItem(name: "ts", value: timestamp),
		URLQueryItem(name: "apikey", value: publicKey),
		URLQueryItem(name: "hash", value: hash),
		]

		guard let url: URL = {
			guard let baseUrl = baseUrl else { return nil }
			var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
			urlComponents?.queryItems = query
			let url = urlComponents?.url
			return url
			}() else { return }

		fetchData(from: url) { dataResult in
			switch dataResult {
			case .success(let data):
				do {
					let result = try JSONDecoder().decode(DataWrapper.self, from: data)
					completion(.success(result.data.results))
				}
				catch {
					completion(.failure(ServiceError.dataError(error)))
				}
			case .failure(let error):
				completion(.failure(error))
				print(error.localizedDescription)
			}
		}
	}

	func loadImage(imageUrl: String, _ completion: @escaping (ImageResult) -> Void) {

		guard let url = URL(string: imageUrl) else { return }
		fetchData(from: url) { imageResult in
			switch imageResult {
			case .success(let data):
				guard let image = UIImage(data: data) else { return }
				completion(.success(image))
			case .failure(let error):
				completion(.failure(error))
				print(error.localizedDescription)
			}
		}
	}
}
