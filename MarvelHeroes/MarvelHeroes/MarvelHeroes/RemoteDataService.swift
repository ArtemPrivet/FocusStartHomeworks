//
//  RemoteService.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 02.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation
import UIKit
enum URLPoints {
	static let creators = "v1/public/creators"
	static let characters = "v1/public/characters"
}
enum ServiceError: Error {
	case invalidURL(Error)
	case invalidInputURL
	case decodingError(Error)
	case browserError
	case serverError
	case noHTTPResponse
	case convertionImageError
}

protocol IRemoteDataService{
	func loadCharacters(_ completion: @escaping (CharacterResult)-> Void)
	func loadCharacterImage(for characterImage: CharacterImage,
					   _ completion: @escaping (CharacterImageResult)-> Void)
}
typealias DataResult = Result<Data, ServiceError>
typealias CharacterResult = Result<[Character], ServiceError>
typealias CharacterImageResult = Result<UIImage, ServiceError>

final class RemoteDataService
{
	private let decoder = JSONDecoder()
	private let limit = 100
	private let session = URLSession(configuration: .default)
	private let stringURL = "https://gateway.marvel.com/"
	private let publicApiKey = "e3181c7b1f125abdc0e6259f0be11722"
	private let privateApiKey = "bc048b9e2276f32e49d0b762b6d93555f9e7d8cb"
	private var timestamp = Int(Date().timeIntervalSince1970)

	private func fetchData(from url: URL, _ completion: @escaping (DataResult)-> Void) {
		print(url)
		session.dataTask(with: url) { (data, response, error) in
			if let error = error {
				completion(.failure(.invalidURL(error)))
				return
			}
			if let httpResponse = response as? HTTPURLResponse {
				switch httpResponse.statusCode {
				case 400..<500:
					print(httpResponse)
					completion(.failure(.browserError))
				case 500..<600:
					completion(.failure(.serverError))
				default:
					break;
				}
			}
			else {
				completion(.failure(.noHTTPResponse))
			}
			if let data = data {
				completion(.success(data))
			}
		}.resume()
	}
}
extension RemoteDataService: IRemoteDataService {
	func loadCharacters(_ completion: @escaping (CharacterResult)-> Void) {
		let hash = "\(timestamp)\(privateApiKey)\(publicApiKey)"
		let resultStringURL = stringURL + URLPoints.characters
		var urlComponents = URLComponents(string: resultStringURL)
		let tsQueryItem = URLQueryItem(name: "ts", value: "\(timestamp)")
		let hashQueryItem = URLQueryItem(name: "hash", value: hash.md5)
		let apiKeyQueryItem = URLQueryItem(name: "apikey", value: publicApiKey)
		let limitQueryItem = URLQueryItem(name: "limit", value: "\(limit)")
		urlComponents?.queryItems = [limitQueryItem, apiKeyQueryItem, tsQueryItem, hashQueryItem]
		guard let url = urlComponents?.url else {
			completion(.failure(.invalidInputURL))
			return
		}
		fetchData(from: url) { result in
			switch result{
			case .success(let data):
				do {
					let object = try JSONDecoder().decode(Response.self, from: data)
					let characters = object.data.results
					completion(.success(characters))
				}
				catch {
					completion(.failure(.decodingError(error)))
				}
			case .failure(let message):
				print(message)
			}
		}
	}
	func loadCharacterImage(for characterImage: CharacterImage,
							_ completion: @escaping (CharacterImageResult)-> Void) {
		let urlString = characterImage.path + "." + characterImage.imageExtension
		guard let url = URL(string: urlString) else { return }
		fetchData(from: url) { result in
			switch result {
			case .success(let data):
				guard let image = UIImage(data: data) else {
					completion(.failure(.convertionImageError))
					return
				}
				completion(.success(image))
			case .failure(let message):
				print(message)
			}
		}
	}
}
