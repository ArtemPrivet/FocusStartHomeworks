//
//  DecoderService.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 02.12.2019.
//

import Foundation

typealias CharactersResult = Result<[Character], ServiceError>
typealias ComicsResult = Result<[Comic], ServiceError>

protocol IDecoderService {
	func decodeCharacters(_ data: Data, _ completion: @escaping (CharactersResult) -> Void)
	func decodeComics(_ completion: @escaping (ComicsResult) -> Void)
}

final class DecoderService {
	private let decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}()
}

extension DecoderService: IDecoderService {

	func decodeCharacters(_ data: Data, _ completion: @escaping (CharactersResult) -> Void) {
		do {
			let result = try CharacterDataWrapper(data: data, decoder: decoder)
			completion(.success(result.data.results))
		} catch {
			completion(.failure(.decodingError(error)))
		}

	}

	func decodeComics(_ completion: @escaping (ComicsResult) -> Void) {

	}
}
