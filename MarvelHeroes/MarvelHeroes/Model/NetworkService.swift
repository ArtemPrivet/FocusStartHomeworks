//
//  NetworkService.swift
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
	private let timestamp = "\(Date().timeIntervalSince1970)"

	private lazy var hash = "\(timestamp)\(URLConstants.privateKey.rawValue)\(URLConstants.publicKey.rawValue)".md5

	private func fetchData(from url: URL, _ completion: @escaping(DataResult) -> Void) {

		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(.sessionError(error)))
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

		let queryItems = [
			URLQueryItem(name: "nameStartsWith", value: name),
			URLQueryItem(name: "limit", value: URLConstants.issueLimit.rawValue),
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "apikey", value: URLConstants.publicKey.rawValue),
			URLQueryItem(name: "hash", value: hash),
		]

		guard let baseUrl = URL(string: URLConstants.baseUrlString.rawValue) else { return }
		var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
		urlComponents?.queryItems = queryItems
		guard let url = urlComponents?.url else { return }

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
