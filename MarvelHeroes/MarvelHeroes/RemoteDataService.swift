//
//  RemoteService.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 02.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation
import UIKit

typealias DataResult = Result<Data, ServiceError>
typealias CharacterResult = Result<[Character]?, ServiceError>
typealias CharacterImageResult = Result<UIImage, ServiceError>
typealias ComicResult = Result<[Comic]?, ServiceError>
protocol IRemoteDataService
{
	func loadCharacters(_ completion: @escaping (CharacterResult) -> Void)
	func loadCharacterImage(for characterImage: Image,
							size: String,
							_ completion: @escaping (CharacterImageResult) -> Void)
	func loadCharacter(by characterName: String, _ completion: @escaping (CharacterResult) -> Void)
	func loadComics(by characterID: Int, _ completion: @escaping (ComicResult) -> Void)
}
final class RemoteDataService
{
	private let decoder = JSONDecoder()
	private let session = URLSession(configuration: .default)
	private var dataTask: URLSessionDataTask?
	private let defaultURL = "https://gateway.marvel.com/"
	private let publicApiKey = "e3181c7b1f125abdc0e6259f0be11722"
	private let privateApiKey = "bc048b9e2276f32e49d0b762b6d93555f9e7d8cb"
	private let hash: String
	private var timestamp = Int(Date().timeIntervalSince1970)
	private let limit = 100
	private let tsQueryItem: URLQueryItem
	private let hashQueryItem: URLQueryItem
	private let apiKeyQueryItem: URLQueryItem
	private let limitQueryItem: URLQueryItem

	init() {
		hash = "\(timestamp)\(privateApiKey)\(publicApiKey)"
		tsQueryItem = URLQueryItem(name: "ts", value: "\(timestamp)")
		hashQueryItem = URLQueryItem(name: "hash", value: hash.md5)
		apiKeyQueryItem = URLQueryItem(name: "apikey", value: publicApiKey)
		limitQueryItem = URLQueryItem(name: "limit", value: "\(limit)")
	}
	private func fetchData(from url: URL, _ completion: @escaping (DataResult) -> Void) {
		dataTask = session.dataTask(with: url) { data, response, error in
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
					break
				}
			}
			else {
				completion(.failure(.noHTTPResponse))
			}
			if let data = data {
				completion(.success(data))
			}
		}
		dataTask?.resume()
	}
}
extension RemoteDataService: IRemoteDataService
{
	func loadCharacters(_ completion: @escaping (CharacterResult) -> Void) {
		let resultStringURL = defaultURL + URLPoints.characters
		var urlComponents = URLComponents(string: resultStringURL)
		urlComponents?.queryItems = [limitQueryItem, apiKeyQueryItem, tsQueryItem, hashQueryItem]
		guard let url = urlComponents?.url else {
			completion(.failure(.invalidInputURL))
			return
		}
		fetchData(from: url) { result in
			switch result{
			case .success(let data):
				do {
					let object = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
					let characters = object.data?.results
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
	func loadCharacterImage(for characterImage: Image,
							size: String,
							_ completion: @escaping (CharacterImageResult) -> Void) {
		guard let path = characterImage.path,
			let imageExtension = characterImage.imageExtension else { return }
		let urlString = "\(path)\(size).\(imageExtension)"
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
	func loadCharacter(by characterName: String, _ completion: @escaping (CharacterResult) -> Void) {
		dataTask?.cancel()
		let resultStringURL = defaultURL + URLPoints.characters
		var urlComponents = URLComponents(string: resultStringURL)
		let nameQueryItem = URLQueryItem(name: "nameStartsWith", value: characterName)
		urlComponents?.queryItems = [nameQueryItem, limitQueryItem, apiKeyQueryItem, tsQueryItem, hashQueryItem]
		guard let url = urlComponents?.url else {
			completion(.failure(.invalidInputURL))
			return
		}
		fetchData(from: url) { result in
			switch result{
			case .success(let data):
				do {
					let object = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
					let characters = object.data?.results
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
	func loadComics(by characterID: Int, _ completion: @escaping (ComicResult) -> Void) {
		let resultStringURL = "\(defaultURL)\(URLPoints.characters)/\(characterID)/comics"
		var urlComponents = URLComponents(string: resultStringURL)
		urlComponents?.queryItems = [limitQueryItem, apiKeyQueryItem, tsQueryItem, hashQueryItem]
		guard let url = urlComponents?.url else {
			completion(.failure(.invalidInputURL))
			return
		}
		fetchData(from: url) { result in
			switch result{
			case .success(let data):
				do {
					let object = try JSONDecoder().decode(ComicDataWrapper.self, from: data)
					let comics = object.data?.results
					completion(.success(comics))
				}
				catch {
					completion(.failure(.decodingError(error)))
				}
			case .failure(let message):
				print(message)
			}
		}
	}
}
