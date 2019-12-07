//
//  NetworkManager.swift
//  
//
//  Created by Михаил Медведев on 20/09/2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

enum QueryItems
{
	static let timeStamp = URLQueryItem(name: "ts", value: "1234")
	static let apiKey = URLQueryItem(name: "apikey", value: "f51eb0a25f6209fc5f6d0da181b49df8")
	static let hash = URLQueryItem(name: "hash",
							value: "dc6408ee9a8b8d655a92e9e7fee968df")
	static let limit = URLQueryItem(name: "limit", value: "50")
	static let heroesAndAuthorsQueryName = "nameStartsWith"
	static let comicsQueryName = "titleStartsWith"
	static let common = [timeStamp, apiKey, hash, limit]
}

final class NetworkManager
{

	private let networkService: INetworkRequestable
	private let jsonDataFetcher: IJSONDataFetchable

	private let cache = NSCache<NSString, UIImage>()

	init(networkService: INetworkRequestable = NetworkService(),
		 jsonDataFetcher: IJSONDataFetchable = JSONDataFetcher()
	) {
		self.networkService = networkService
		self.jsonDataFetcher = jsonDataFetcher
	}

	func fetchImage(url: URL, completion: @escaping (Result<UIImage, NetworkServiceError>) -> Void) {

		if let cachedVersion = cache.object(forKey: url.absoluteString as NSString) {
			completion(.success(cachedVersion))
		}
		else {
		networkService.request(to: url, type: .get,
							   headers: nil, with: nil,
							   cancelsExitingDataTask: false) { [weak self] result in
			switch result {
			case .success(let data):
				guard let image = UIImage(data: data) else {
					completion(.failure(.wrongData))
					return
				}
				self?.cache.setObject(image, forKey: url.absoluteString as NSString)
				completion(.success(image))
			case .failure:
				completion(.failure(.noData))
			}
		}
		}
	}

	func makeApiURL(addingPathToComponents: String, queryItems: [URLQueryItem], withSearchText: String) -> URL? {

		var components = URLComponents()
		components.scheme = "http"
		components.host = "gateway.marvel.com"
		components.path = "/v1/public/"
		components.path += addingPathToComponents
		components.queryItems = queryItems

		return components.url
	}
}

extension NetworkManager: IRepositoryDataSource
{
	func fetchMarvelItems<T: Decodable>(type: MarvelItemType,
										appendingPath: String?,
										withId: Int?,
										searchText: String,
										completion: @escaping (Result<T, NetworkServiceError>) -> Void) {

		var tempUrl: URL?

		var itemTypeQuery: [URLQueryItem] {
			var queries = QueryItems.common
			switch type {
			case .heroes, .authors:
				queries.append(URLQueryItem(name: QueryItems.heroesAndAuthorsQueryName, value: searchText))
			case .comics:
				queries.append(URLQueryItem(name: QueryItems.comicsQueryName, value: searchText))
			}
			return queries
		}

		if let id = withId {
			tempUrl = makeApiURL(addingPathToComponents: (appendingPath ?? "") + "/\(id)/" + type.rawValue,
			queryItems: QueryItems.common, withSearchText: searchText)
		}
		else {
			tempUrl = makeApiURL(addingPathToComponents: type.rawValue + (appendingPath ?? ""),
				queryItems: itemTypeQuery, withSearchText: searchText)
		}

		guard let url = tempUrl else { return }

		let jsonDataFetcher = JSONDataFetcher()
		jsonDataFetcher.fetchJSONData(url: url, requestType: .get,
									  headers: nil, cancelsExitingDataTask: true,
									  completion: completion)
	}

	func fetchMarvelItem<T: Decodable>(resourceLink: String,
										completion: @escaping (Result<T, NetworkServiceError>) -> Void) {

		let queries = QueryItems.common

		guard var components = URLComponents(string: resourceLink) else {
			completion(.failure(.wrongURL))
			return
		}
		components.queryItems = queries

		guard let url = components.url else {
			completion(.failure(.wrongURL))
			return
		}

		let jsonDataFetcher = JSONDataFetcher()
		jsonDataFetcher.fetchJSONData(url: url, requestType: .get,
									  headers: nil, cancelsExitingDataTask: true,
									  completion: completion)
	}
}
