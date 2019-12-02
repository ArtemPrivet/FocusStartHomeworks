//
//  ImageDownloadService.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 02.12.2019.
//

import Foundation

typealias ImageDataResult = Result<Data, ServiceError>

protocol IImageDownloadService {
	func loadImage(from url: URL?, _ completion: @escaping (ImageDataResult) -> Void)
}

class ImageDownloadService {
	private var imageDataCache = NSCache<NSString, NSData>()
}

extension ImageDownloadService: IImageDownloadService {
	func loadImage(from url: URL?, _ completion: @escaping (ImageDataResult) -> Void) {

		guard let url = url else {
			completion(.failure(.cannotMakeURL))
			return
		}

		if let cachedImageData = imageDataCache.object(forKey: url.absoluteString as NSString) {
			completion(.success(cachedImageData as Data))
			return
		}

		let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5)
		let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in

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

			self?.imageDataCache.setObject(data as NSData,
										   forKey: url.absoluteString as NSString)

			completion(.success(data))
			return
		}
		dataTask.resume()
	}
}
