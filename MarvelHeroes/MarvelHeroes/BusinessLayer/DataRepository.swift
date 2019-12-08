//
//  DataRepository.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 08.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

typealias DataResult = Result<Data, ServiceError>
typealias ImageResult = Result<UIImage, ServiceError>

protocol IDataRepository
{
	func fetchData(from url: URL, _ completion: @escaping(DataResult) -> Void)
	func loadImage(urlString: String, _ completion: @escaping (ImageResult) -> Void)
}
// swiftlint:disable:next required_final
class DataRepository: IDataRepository
{
	func fetchData(from url: URL, _ completion: @escaping(DataResult) -> Void) {
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
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

	func loadImage(urlString: String, _ completion: @escaping (ImageResult) -> Void) {
		guard let url = URL(string: urlString) else { return }
		fetchData(from: url) { imageResult in
			switch imageResult {
			case .success(let data):
				guard let image = UIImage(data: data) else {
					completion(.failure(ServiceError.dataError(NSError())))
					return }
				completion(.success(image))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
