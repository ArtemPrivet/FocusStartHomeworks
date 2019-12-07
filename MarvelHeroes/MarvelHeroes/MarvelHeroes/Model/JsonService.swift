//
//  JsonService.swift
//  MarvelHeroes
//
//  Created by MacBook Air on 02.12.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import Foundation

typealias DataResult = Result<Data, ServiceError>
typealias Responce1Result = Result<Response1, ServiceError>
typealias CharacterResult = Result<Results, ServiceError>

protocol IJsonService {
	func loadResult(urlString: String, _ completion: @escaping(Responce1Result) -> Void)
}

class JsonService {
	private let decoder = JSONDecoder()

	private func fetchData(from url: URL, _ completion: @escaping(DataResult) -> Void) {
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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

extension JsonService: IJsonService {
	func loadResult(urlString: String, _ completion: @escaping (Responce1Result) -> Void) {
		guard let newUrl = URL(string: urlString) else { return }
		fetchData(from: newUrl) { dataResult in
			switch dataResult {
			case .success(let data):
				do {
					let result = try self.decoder.decode(Response1.self, from: data)
					completion(.success(result))
				} catch {
					completion(.failure(ServiceError.dataError(error)))
					return
				}
			case .failure(let error):
				completion(.failure(error))
				print(error.localizedDescription)
			}
		}
	}


}
