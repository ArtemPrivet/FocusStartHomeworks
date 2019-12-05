//
//  Repository.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import UIKit

typealias ImageResult = Result<UIImage, ServiceError>

typealias CharacterResultCompletion = (CharactersResult) -> Void
typealias ComicsResultCompletion = (ComicsResult) -> Void
typealias CreatorResultCompletion = (CreatorsResult) -> Void
typealias ImageResultCompletion = (ImageResult) -> Void

typealias IItemsRepository = ICharactersRepository & IComicsRepository & ICreatorsRepository

// MARK: - Protocol ICharactersRepository
protocol ICharactersRepository
{
	func fetchCharacters(name: String,
						 _ completion: @escaping CharacterResultCompletion)
}

// MARK: - Protocol IComicsRepository
protocol IComicsRepository
{
	func fetchComics(title: String,
					 _ completion: @escaping ComicsResultCompletion)
	func fetchComics(fromType type: ItemType,
					 itemId: String,
					 _ completion: @escaping ComicsResultCompletion)
}

// MARK: - Protocol ICreatorsRepository
protocol ICreatorsRepository
{
	func fetchCreators(lastName: String,
					   _ completion: @escaping CreatorResultCompletion)
	func fetchCreator(comicID: String,
					  _ completion: @escaping CreatorResultCompletion)
}

// MARK: - Protocol IImagesRepository
protocol IImagesRepository
{
	func fetchImage(fromURL url: URL?,
					_ completion: @escaping (ImageResult) -> Void)
}

final class ItemsRepository
{
	// MARK: Private methods
	private var imageDownloadServise: IImageDownloadService
	private var networkServise: IMarvelAPIService
	private var decoderServise: IDecoderService

	// MARK: Initialization
	init(jsonPlaceholderService: IMarvelAPIService,
		 decoderServise: IDecoderService,
		 imageDownloadServise: IImageDownloadService) {

		self.networkServise = jsonPlaceholderService
		self.decoderServise = decoderServise
		self.imageDownloadServise = imageDownloadServise
	}
}

// MARK: - ICharactersRepository
extension ItemsRepository: ICharactersRepository
{
	func fetchCharacters(name: String,
						 _ completion: @escaping CharacterResultCompletion) {

		networkServise.loadCharacters(name: name) { [weak self] result in
			switch result {
			case .success(let data):
				self?.decoderServise.decodeCharacters(data) { result in
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
				return
			}
		}
	}
}

// MARK: - IComicsRepository
extension ItemsRepository: IComicsRepository
{
	func fetchComics(title: String, _ completion: @escaping ComicsResultCompletion) {
		networkServise.loadComics(title: title) { [weak self] result in
			switch result {
			case .success(let data):
				self?.decoderServise.decodeComics(data) { result in
					switch result {
					case .success(let comics):
						completion(.success(comics))
						return
					case .failure(let error):
						completion(.failure(error))
						return
					}
				}
			case .failure(let error):
				completion(.failure(error))
				return
			}
		}
	}

	func fetchComics(fromType type: ItemType,
					 itemId: String,
					 _ completion: @escaping ComicsResultCompletion) {

		switch type {
		case .charactor: self.fetchComics(characterId: itemId, completion)
		case .comic: break
		case .creator: self.fetchComics(creatorId: itemId, completion)
		}
	}

	private func fetchComics(characterId: String,
							 _ completion: @escaping ComicsResultCompletion) {
		networkServise.loadComics(characterID: characterId) { result in
			self.fetchComics(result: result, completion)
		}
	}

	private func fetchComics(creatorId: String,
							 _ completion: @escaping ComicsResultCompletion) {
		networkServise.loadComics(creatorID: creatorId) { [weak self] result in
			self?.fetchComics(result: result, completion)
		}
	}

	private func fetchComics(result: ComicDataWrapperResult,
							 _ completion: @escaping ComicsResultCompletion) {

		switch result {
		case .success(let data):
			self.decoderServise.decodeComics(data) { result in
				switch result {
				case .success(let comics):
					completion(.success(comics))
					return
				case .failure(let error):
					completion(.failure(error))
					return
				}
			}
		case .failure(let error):
			completion(.failure(error))
			return
		}
	}
}

// MARK: - IComicsRepository
extension ItemsRepository: ICreatorsRepository
{
	func fetchCreators(lastName: String,
					   _ completion: @escaping CreatorResultCompletion) {

		networkServise.loadCreators(lastName: lastName) { [weak self] result in
			switch result {
			case .success(let data):
				self?.decoderServise.decodeCreator(data) { result in
					switch result {
					case .success(let creators):
						completion(.success(creators))
						return
					case .failure(let error):
						completion(.failure(error))
						return
					}
				}
			case .failure(let error):
				completion(.failure(error))
				return
			}
		}
	}

	func fetchCreator(comicID: String,
					  _ completion: @escaping CreatorResultCompletion) {

		networkServise.loadCreators(comicID: comicID) { [weak self] result in
			switch result {
			case .success(let data):
				self?.decoderServise.decodeCreator(data) { result in
					switch result {
					case .success(let creator):
						completion(.success(creator))
						return
					case .failure(let error):
						completion(.failure(error))
						return
					}
				}
			case .failure(let error):
				completion(.failure(error))
				return
			}
		}
	}
}

// MARK: - IImagesRepository
extension ItemsRepository: IImagesRepository
{
	func fetchImage(fromURL url: URL?,
					_ completion: @escaping (ImageResult) -> Void) {

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
