//
//  NetworkService.swift
//  MarvelHeroes
//
//  Created by Антон on 01.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import Foundation

final class NetworkService
{
	private let publicKey = "0868a1cf9476b6000657f58609a76967"
	private let privateKey = "73d98d99bf5723600e96258107b9e691035bb7a1"
	private var timestamp: String?
	private var hash: String {
		let newTimestamp = String(Date().toMillis())
		timestamp = newTimestamp
		let result = "\(newTimestamp + privateKey + publicKey)"
		return result.md5
	}
	private var charactersData: CharacterDataWrapper?

	private let beginnedUrl = "https://gateway.marvel.com/v1/public/characters"
	//private var urlComponents = URLComponents(string: "https://gateway.marvel.com/v1/public/characters")
}

extension NetworkService: INetworkProtocol
{
	func getHeroesImageData(url: URL, callBack: @escaping (Data) -> Void) {
		URLSession.shared.dataTask(with: url) { data, _, error in
			guard let data = data, error == nil else { return }
			callBack(data)
		}
		.resume()
	}

	func getHeroes(charactersName: String, callBack: @escaping (CharacterDataWrapper) -> Void) {
		let newHash = hash
		guard let timestamp = timestamp else { return }
		guard var urlComponents = URLComponents(string: beginnedUrl) else { return }
		urlComponents.queryItems = [
			URLQueryItem(name: "nameStartsWith", value: charactersName),
			URLQueryItem(name: "orderBy", value: "name"),
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "apikey", value: publicKey),
			URLQueryItem(name: "hash", value: newHash),
		]
		guard let url = urlComponents.url else { return }
		let request = URLRequest(url: url)
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
				print("Error 1 = \(error.localizedDescription)")
				return
			}
			if let data = data, response != nil {
				do {
					let result = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
					callBack(result)
				}
				catch let error as NSError {
					print("Error 2 - \(error.localizedDescription)")
				}
			}
		}
		task.resume()
	}
}
