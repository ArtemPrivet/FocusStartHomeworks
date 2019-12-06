//
//  DecoderService.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 02.12.2019.
//

import Foundation

typealias CharactersResult = Result<[Character], ServiceError>
typealias ComicsResult = Result<[Comic], ServiceError>
typealias CreatorsResult = Result<[Creator], ServiceError>

protocol IDecoderService
{
	func decodeCharacters(_ data: Data, _ completion: @escaping (CharactersResult) -> Void)
	func decodeComics(_ data: Data, _ completion: @escaping (ComicsResult) -> Void)
	func decodeCreator(_ data: Data, _ completion: @escaping (CreatorsResult) -> Void)
}

final class DecoderService
{
	private let decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}()

	let dispatchQueueDecoding =
		DispatchQueue(label: "com.marvelHeroes.decodeCharacters",
					  qos: .userInitiated,
					  attributes: .concurrent)
}

extension DecoderService: IDecoderService
{

	func decodeCharacters(_ data: Data, _ completion: @escaping (CharactersResult) -> Void) {
		dispatchQueueDecoding.async { [weak self] in

			guard let self = self else { return }
			do {
				let result = try CharacterDataWrapper(data: data,
													  decoder: self.decoder)
				completion(.success(result.data.results))
			}
			catch {
				completion(.failure(.decodingError(error)))
			}
		}
	}

	func decodeComics(_ data: Data, _ completion: @escaping (ComicsResult) -> Void) {
		dispatchQueueDecoding.async { [weak self] in

			guard let self = self else { return }
			do {
				let result = try ComicDataWrapper(data: data,
												  decoder: self.decoder)
				completion(.success(result.data.results))
			}
			catch {
				completion(.failure(.decodingError(error)))
			}
		}
	}

	func decodeCreator(_ data: Data, _ completion: @escaping (CreatorsResult) -> Void) {
		dispatchQueueDecoding.async { [weak self] in

			guard let self = self else { return }
			do {
				let result = try CreatorDataWrapper(data: data,
												  decoder: self.decoder)
				completion(.success(result.data.results))
			}
			catch {
				completion(.failure(.decodingError(error)))
			}
		}
	}
}
