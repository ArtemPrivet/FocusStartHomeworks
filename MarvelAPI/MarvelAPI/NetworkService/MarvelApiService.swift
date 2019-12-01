//
//  MarvelApiService.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

typealias CharactersResult = Result<CharacterDataWrapper, ServiceError>
typealias ImageResult = Result<UIImage, ServiceError>

typealias DataResult = Result<Data, ServiceError>


protocol IMarvelApiService {
	func loadCharacters(url: URL, _ completion: @escaping(CharactersResult) -> Void)
	func loadCharcterImage(urlString: String, _ completion: @escaping(ImageResult) -> Void)
}

class MarvelApiService {
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

extension MarvelApiService: IMarvelApiService {
	func loadCharcterImage(urlString: String, _ completion: @escaping (ImageResult) -> Void) {
		guard let url = URL(string: urlString) else { return }
		fetchData(from: url) { imageResult in
			switch imageResult {
			case .success(let data):
				guard let image = UIImage(data: data) else { return }
				print("success")
				completion(.success(image))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	func loadCharacters( url: URL, _ completion: @escaping (CharactersResult) -> Void) {
		fetchData(from: url) { dataResult in
			switch dataResult {
			case .success(let data):
				print(data)
				do {
					let characters = try self.decoder.decode(CharacterDataWrapper.self, from: data)
					completion(.success(characters))
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
