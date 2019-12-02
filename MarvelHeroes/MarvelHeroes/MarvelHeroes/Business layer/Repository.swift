//
//  Repository.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import UIKit

typealias ImageResult = Result<UIImage, ServiceError>

protocol ICharactersRepository {
	func fetchCharacters(name: String, _ completion: @escaping (CharactersResult) -> Void)
}

protocol IComicsRepository {
	func fetchComics(name: String, _ completion: @escaping (ComicsResult) -> Void)
}

protocol IImagesRepository {
	func fetchImage(from path: String, extension: String, _ completion: @escaping (ImageResult) -> Void)
}

class CharactersRepository {

	private var imageDownloadServise: IImageDownloadService
	private var networkServise: IMarvelAPIService
	private var decoderServise: IDecoderService

	init(jsonPlaceholderService: IMarvelAPIService, decoderServise: IDecoderService, imageDownloadServise: IImageDownloadService) {
		self.networkServise = jsonPlaceholderService
		self.decoderServise = decoderServise
		self.imageDownloadServise = imageDownloadServise
	}
}

extension CharactersRepository: ICharactersRepository {

	func fetchCharacters(name: String, _ completion: @escaping (CharactersResult) -> Void) {
		networkServise.loadCharacters(name: name) { result in
			switch result {
			case .success(let data):
				self.decoderServise.decodeCharacters(data) { result in
					switch result {
					case .success(let characters):
						completion(.success(characters))
						return
					case .failure(let error):
						completion(.failure(error))
						return
					}
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}

extension CharactersRepository: IImagesRepository {
	func fetchImage(from path: String, extension: String, _ completion: @escaping (ImageResult) -> Void) {
		let url = URL(string: path)?.appendingPathExtension(`extension`)
		imageDownloadServise.loadImage(from: url) { result in
			switch result {
			case .success(let data):
				guard let image = UIImage(data: data) else {
					completion(.failure(.cannotCreateImageFromData))
					return
				}
				completion(.success(image))
				return
			case .failure(let error):
				completion(.failure(error))
				return
			}
		}
	}


}
