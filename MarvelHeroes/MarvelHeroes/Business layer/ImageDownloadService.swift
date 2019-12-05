//
//  ImageDownloadService.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 02.12.2019.
//

import Foundation

typealias ImageDataResult = Result<Data, ServiceError>

protocol IImageDownloadService
{
	func loadImage(from url: URL?, _ completion: @escaping (ImageDataResult) -> Void)
}

final class ImageDownloadService
{

	init() {
		let memoryCapacity = 500 * 1024 * 1024
		let diskCapacity = 500 * 1024 * 1024
		let imageDataCache = URLCache(memoryCapacity: memoryCapacity,
									  diskCapacity: diskCapacity,
									  diskPath: "imagesCache")
		URLCache.shared = imageDataCache
	}
}

extension ImageDownloadService: IImageDownloadService
{
	func loadImage(from url: URL?, _ completion: @escaping (ImageDataResult) -> Void) {

		guard let url = url else {
			completion(.failure(.cannotMakeURL))
			return
		}

		let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5)
		let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in

			if let error = error {
				completion(.failure(.sessionError(error)))
				return
			}

			guard
				let httpResponse = response as? HTTPURLResponse,
				(200..<300) ~= httpResponse.statusCode else {
					completion(.failure(.statusCodeError((response as? HTTPURLResponse)?.statusCode ?? 500)))
					return
			}

			guard let data = data else {
				completion(.failure(.noData))
				return
			}

			completion(.success(data))
			return
		}
		dataTask.resume()
	}
}
