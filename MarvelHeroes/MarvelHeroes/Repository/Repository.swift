//
//  Rpository.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation

final class Repository
{
	private let session = URLSession(configuration: .default)
	private var dataTask: URLSessionDataTask?
// MARK: - Загрузка списков
// Загрузить список сущностей
	func loadEntities<T: Decodable>(with nameStarts: String = "",
									directory: String,
									queryParameter: String,
						completion: @escaping (Result<T, ServiceError>) -> Void)  {
		var additionParameters: [URLQueryItem] = []
		if nameStarts.isEmpty == false {
			additionParameters.append(URLQueryItem(name: queryParameter, value: nameStarts))
		}
		fetchData(directory: directory, additionParameters: additionParameters){ result in
			switch result {
			case .success(let data):
				do {
					let resultData = try JSONDecoder().decode(T.self, from: data)
					DispatchQueue.main.async {
						completion(.success(resultData))
					}
				}
				catch {
					DispatchQueue.main.async {
						completion( .failure(.parsingError(error)))
					}
				}
			case .failure(let error):
				DispatchQueue.main.async {
					completion( .failure(error))
				}
			}
		}
	}
// MARK: - Загрузка по ID
//Загрузить доп список для сущности
	func loadAccessoryByEntityID<T: Decodable>(from directory: String,
						completion: @escaping (Result<T, ServiceError>) -> Void)  {
		fetchData(directory: directory){ result in
			switch result {
			case .success(let data):
				do {
					let resultData = try JSONDecoder().decode(T.self, from: data)
					DispatchQueue.main.async {
						completion(.success(resultData))
					}
				}
				catch {
					DispatchQueue.main.async {
						completion( .failure(.parsingError(error)))
					}
				}
			case .failure(let error):
				DispatchQueue.main.async {
					completion( .failure(error))
				}
			}
		}
	}
}
// MARK: - Приватные методы
private extension Repository
{
	// Загрузка данных
	func fetchData(directory: String,
				   additionParameters: [URLQueryItem] = [],
				   _ completion: @escaping (Result<Data, ServiceError>) -> Void ) {
		dataTask?.cancel()
		var urlComponent = URLComponents(string: Constants.marvelAPIUrl + directory)
		let timestamp = String(Int64(Date().timeIntervalSince1970))
		let hash = ("\(timestamp)\(Constants.privateKey)\(Constants.publicKey)").md5()
		urlComponent?.queryItems = [
			URLQueryItem(name: "limit", value: String(Constants.limit)),
			URLQueryItem(name: "apikey", value: Constants.publicKey),
			URLQueryItem(name: "ts", value: String(timestamp)),
			URLQueryItem(name: "hash", value: hash),
		]
		if urlComponent?.queryItems != nil {
			urlComponent?.queryItems? += additionParameters
		}
		else {
			urlComponent?.queryItems = additionParameters
		}
		guard let url = urlComponent?.url else { return }
		dataTask = session.dataTask(with: url) { data, response, error in
			if error != nil {
				DispatchQueue.main.async {
					completion( .failure(.networkError))
				}
			}
			if let response = response as? HTTPURLResponse, response.statusCode != 200 {
				DispatchQueue.main.async {
					completion( .failure(.httpError(response.statusCode)))
				}
			}
			if let data = data {
				completion( .success(data))
			}
			else {
				DispatchQueue.main.async {
					completion( .failure(.dataError))
				}
			}
		}
		dataTask?.resume()
	}
}
