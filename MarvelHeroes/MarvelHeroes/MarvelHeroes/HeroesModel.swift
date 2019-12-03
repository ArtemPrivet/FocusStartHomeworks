//
//  HeroesModel.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 02.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation

protocol IHeroesModel {
	func loadData()
}
final class HeroesModel: IHeroesModel
{
	let publicApiKey = "e3181c7b1f125abdc0e6259f0be11722"
	let privateApiKey = "bc048b9e2276f32e49d0b762b6d93555f9e7d8cb"
	let stringURL = "https://gateway.marvel.com/v1/public/characters"
	let timestamp = Int(Date().timeIntervalSince1970)

	func loadData() {
		/*let hash = "\(timestamp)\(privateApiKey)\(publicApiKey)"

		let session = URLSession(configuration: .default)

		var urlComponents = URLComponents(string: stringURL)
		let tsQueryItem = URLQueryItem(name: "ts", value: "\(timestamp)")
		let hashQueryItem = URLQueryItem(name: "hash", value: hash.md5)
		let apiKeyQueryItem = URLQueryItem(name: "apikey", value: publicApiKey)

		urlComponents?.queryItems = [apiKeyQueryItem, tsQueryItem, hashQueryItem]
		guard let url = urlComponents?.url else { return }
		print(url)
		let request = URLRequest(url: url)
		session.dataTask(with: request) { (data, responce, error) in
			if let error = error {
				print(error)
			}
			if let data = data {
				do {
					let object = try JSONDecoder().decode(Response.self, from: data)
					print(object)
				}
				catch {
					//completion(.failure(.decodingError(error)))
					print(error)
				}
			}

		}.resume()*/
	}
}
