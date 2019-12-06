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

	private let beginnerURLFromDownloadHero = "https://gateway.marvel.com/v1/public/characters"
	//private var urlComponents = URLComponents(string: "https://gateway.marvel.com/v1/public/characters")
	//https://gateway.marvel.com:443/v1/public/characters/1009609/comics?apikey=0868a1cf9476b6000657f58609a76967

}

extension NetworkService: INetworkProtocol
{
	func getComicsAtHeroesID(id: String, callBack: @escaping (SeriesDataWrapper) -> Void) {
		let newHash = hash
		guard let timestamp = timestamp else { return }
		guard var urlComponents = URLComponents(string: beginnerURLFromDownloadHero + "/\(id)/" + "comics") else { return }
		urlComponents.queryItems = [
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "apikey", value: publicKey),
			URLQueryItem(name: "hash", value: newHash),
		]
		guard let url = urlComponents.url else { return }
		let request = URLRequest(url: url)
		let task = URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
			if let error = error {
				fatalError(error.localizedDescription)
			}
			if let data = data {
				do {
					let result = try JSONDecoder().decode(SeriesDataWrapper.self, from: data)
					callBack(result)
				}
				catch let error as NSError {
					fatalError(error.localizedDescription)
				}
			}
		})
		task.resume()
	}

	func getImageData(url: URL, callBack: @escaping (Data) -> Void) {
		URLSession.shared.dataTask(with: url) { data, _, error in
			guard let data = data, error == nil else { return }
			callBack(data)
		}
		.resume()
	}

	func getHeroes(charactersName: String, callBack: @escaping (CharacterDataWrapper) -> Void) {
		let newHash = hash
		guard let timestamp = timestamp else { return }
		guard var urlComponents = URLComponents(string: beginnerURLFromDownloadHero) else { return }
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
				fatalError(error.localizedDescription)
			}
			if let data = data, response != nil {
				do {
					let result = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
					callBack(result)
				}
				catch let error as NSError {
					fatalError(error.localizedDescription)
				}
			}
		}
		task.resume()
	}
}
