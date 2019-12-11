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
	private let decoder = JSONDecoder()
	private let characterURL = "https://gateway.marvel.com/v1/public/characters"
	private let comicsURL = "https://gateway.marvel.com/v1/public/comics"
	private let creatorsURL = "https://gateway.marvel.com/v1/public/creators"
	private var hash: String {
		let newTimestamp = String(Date().toMillis())
		timestamp = newTimestamp
		let result = "\(newTimestamp + privateKey + publicKey)"
		return result.md5
	}
	private var charactersData: CharacterDataWrapper?

	private func getURLComponentsForHeroScreen(hash: String,
											   timestamp: String,
											   presenterType: PresenterType,
											   placeholderText: String) -> URLComponents? {
		var urlComponents = URLComponents(string: beginnerURLFromDownloadHero)
		urlComponents?.queryItems = [
			URLQueryItem(name: "nameStartsWith", value: placeholderText),
			URLQueryItem(name: "orderBy", value: "name"),
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "apikey", value: publicKey),
			URLQueryItem(name: "hash", value: hash),
		]
		return urlComponents
	}
	private func getURLComponentsForComicsScreen(hash: String,
												 timestamp: String,
												 presenterType: PresenterType,
												 placeholderText: String) -> URLComponents? {
		var urlComponents = URLComponents(string: comicsURL)
		urlComponents?.queryItems = [
			URLQueryItem(name: "titleStartsWith", value: placeholderText),
			URLQueryItem(name: "orderBy", value: "title"),
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "apikey", value: publicKey),
			URLQueryItem(name: "hash", value: hash),
		]
		return urlComponents
	}
	private func getURLComponentsForAuthorsScreen(hash: String,
												  timestamp: String,
												  presenterType: PresenterType,
												  placeholderText: String) -> URLComponents? {
		var urlComponents = URLComponents(string: creatorsURL)
		urlComponents?.queryItems = [
			URLQueryItem(name: "nameStartsWith", value: placeholderText),
			URLQueryItem(name: "orderBy", value: "firstName"),
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "apikey", value: publicKey),
			URLQueryItem(name: "hash", value: hash),
		]
		return urlComponents
	}

	private func getURLComponentsForHeroScreenDetail(hash: String,
													 timestamp: String,
													 presenterType: PresenterType,
													 placeholderText: String) -> URLComponents? {
		var urlComponents = URLComponents(string: beginnerURLFromDownloadHero + "/\(placeholderText)/" + "comics")
		urlComponents?.queryItems = [
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "apikey", value: publicKey),
			URLQueryItem(name: "hash", value: hash),
		]
		return urlComponents
	}

	private func getURLComponentsForComicsScreenDetail(hash: String,
													   timestamp: String,
													   presenterType: PresenterType,
													   placeholderText: String) -> URLComponents? {
		var urlComponents = URLComponents(string: comicsURL + "/\(placeholderText)/" + "creators")
		urlComponents?.queryItems = [
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "apikey", value: publicKey),
			URLQueryItem(name: "hash", value: hash),
		]
		return urlComponents
	}

	private func getURLComponentsForAuthorsScreenDetail(hash: String,
														timestamp: String,
														presenterType: PresenterType,
														placeholderText: String) -> URLComponents? {
		var urlComponents = URLComponents(string: creatorsURL + "/\(placeholderText)/" + "comics")
		urlComponents?.queryItems = [
			 URLQueryItem(name: "limit", value: "100"),
			 URLQueryItem(name: "ts", value: timestamp),
			 URLQueryItem(name: "apikey", value: publicKey),
			 URLQueryItem(name: "hash", value: hash),
		]
		return urlComponents
	}

	private func getURLComponentsForHeroesInComics(hash: String,
												   timestamp: String,
												   presenterType: PresenterType,
												   placeholderText: String) -> URLComponents? {
		var urlComponents = URLComponents(string: comicsURL + "/\(placeholderText)/" + "characters")
		urlComponents?.queryItems = [
			URLQueryItem(name: "limit", value: "100"),
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "apikey", value: publicKey),
			URLQueryItem(name: "hash", value: hash),
		]
		return urlComponents
	}

	private func getURLComponents(presenterType: PresenterType,
											   placeholderText: String) -> URLComponents? {
		let newHash = hash
		guard let timestamp = timestamp else { return nil }
		switch presenterType {
		case .heroScreen:
			return getURLComponentsForHeroScreen(hash: newHash, timestamp: timestamp, presenterType: presenterType,
												 placeholderText: placeholderText)
		case .heroScreenDetail:
			return getURLComponentsForHeroScreenDetail(hash: newHash, timestamp: timestamp, presenterType: presenterType,
													   placeholderText: placeholderText)
		case .comicsScreenDetail:
			return getURLComponentsForComicsScreenDetail(hash: newHash, timestamp: timestamp, presenterType: presenterType,
														 placeholderText: placeholderText)
		case .authorsScreenDetail:
			return getURLComponentsForAuthorsScreenDetail(hash: newHash, timestamp: timestamp, presenterType: presenterType,
														  placeholderText: placeholderText)
		case .presentHeroesInComics:
			return getURLComponentsForHeroesInComics(hash: newHash, timestamp: timestamp, presenterType: presenterType,
													 placeholderText: placeholderText)
		case .comicsScreen:
			return getURLComponentsForComicsScreen(hash: newHash, timestamp: timestamp, presenterType: presenterType,
												   placeholderText: placeholderText)
		case .authorsScreen:
			return getURLComponentsForAuthorsScreen(hash: newHash, timestamp: timestamp, presenterType: presenterType,
													placeholderText: placeholderText)
		}
	}

	private let beginnerURLFromDownloadHero = "https://gateway.marvel.com/v1/public/characters"
	//private var urlComponents = URLComponents(string: "https://gateway.marvel.com/v1/public/characters")
	//https://gateway.marvel.com:443/v1/public/characters/1009609/comics?apikey=0868a1cf9476b6000657f58609a76967
	private func fetchData(presenterType: PresenterType,
								 placeholderText: String,
								 callBack: @escaping (DataResult) -> Void) {
		guard let url = getURLComponents(presenterType: presenterType, placeholderText: placeholderText)?.url else {
			callBack(.failure(.wrongUrl))
			return
		}
		let request = URLRequest(url: url)
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
				callBack(.failure(.session(error)))
			}
			guard let response = response as? HTTPURLResponse else {
				callBack(.failure(.noHTTPResponse))
				return
			}
			switch response.statusCode {
			case 400..<500:
				callBack(.failure(.clientError))
			case 500..<600:
				callBack(.failure(.serverError))
			default:
				break
			}
			if let data = data {
				callBack(.success(data))
			}
			else {
				callBack(.failure(.noData))
			}
		}
		task.resume()
	}
}

extension NetworkService: INetworkProtocol
{
	func getComicsAtHeroesID(id: String, callBack: @escaping (SeriesResult) -> Void) {
		fetchData(presenterType: .heroScreenDetail, placeholderText: id, callBack: { [weak self] dataResult in
			do {
				guard let series = try self?.decoder.decode(SeriesDataWrapper.self, from: dataResult.get()) else { return }
				callBack(.success(series))
			}
			catch {
				callBack(.failure(.decode(error)))
			}
		})
	}

	func getComicsAtNameStartsWith(string: String, callBack: @escaping (SeriesResult) -> Void) {
		fetchData(presenterType: .comicsScreen, placeholderText: string, callBack: { [weak self] dataResult in
			do {
				guard let series = try self?.decoder.decode(SeriesDataWrapper.self, from: dataResult.get()) else { return }
				callBack(.success(series))
			}
			catch {
				callBack(.failure(.decode(error)))
			}
		})
	}

	func getComicsAtCreatorsID(id: String, callBack: @escaping (SeriesResult) -> Void) {
		fetchData(presenterType: .authorsScreenDetail, placeholderText: id, callBack: { [weak self] dataResult in
			do {
				guard let series = try self?.decoder.decode(SeriesDataWrapper.self, from: dataResult.get()) else { return }
				callBack(.success(series))
			}
			catch {
				callBack(.failure(.decode(error)))
			}
		})
	}

	func getCharacterInComicsAtComicsID(id: String, callBack: @escaping (CharacterResult) -> Void) {
		fetchData(presenterType: .presentHeroesInComics, placeholderText: id, callBack: { [weak self] dataResult in
			do {
				guard let character = try self?.decoder.decode(CharacterDataWrapper.self, from: dataResult.get()) else { return }
				callBack(.success(character))
			}
			catch {
				callBack(.failure(.decode(error)))
			}
		})
	}

	func getAuthorsAtNameStartsWith(string: String, callBack: @escaping (CreatorsResult) -> Void) {
		fetchData(presenterType: .authorsScreen, placeholderText: string, callBack: { [weak self] dataResult in
			do {
				guard let creators = try self?.decoder.decode(CreatorDataWrapper.self, from: dataResult.get()) else { return }
				callBack(.success(creators))
			}
			catch {
				callBack(.failure(.decode(error)))
			}
		})
	}

	func getAuthorsAtComicsId(id: String, callBack: @escaping (CreatorsResult) -> Void) {
		fetchData(presenterType: .comicsScreenDetail, placeholderText: id, callBack: { [weak self] dataResult in
			do {
				guard let comics = try self?.decoder.decode(CreatorDataWrapper.self, from: dataResult.get()) else { return }
				callBack(.success(comics))
			}
			catch {
				callBack(.failure(.decode(error)))
			}
		})
	}

	func getImageData(url: URL, callBack: @escaping (Data) -> Void) {
		URLSession.shared.dataTask(with: url) { data, _, error in
			guard let data = data, error == nil else { return }
			callBack(data)
		}
		.resume()
	}

	func getHeroes(charactersName: String, callBack: @escaping (CharacterResult) -> Void) {
		self.fetchData(presenterType: .heroScreen, placeholderText: charactersName) { [weak self] dataResult in
			do {
				guard let data = try self?.decoder.decode(CharacterDataWrapper.self, from: dataResult.get()) else { return }
				callBack(.success(data))
			}
			catch {
				callBack(.failure(.decode(error)))
			}
		}
	}
}
