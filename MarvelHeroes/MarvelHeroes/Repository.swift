//
//  Repository.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 02.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import UIKit
protocol IRepository
{
	func loadCharacters(_ completion: @escaping (CharacterResult) -> Void)
	func loadCharacterImage(for characterImage: Image,
							size: String,
							_ completion: @escaping (CharacterImageResult) -> Void)
	func loadCharacter(by characterName: String, _ completion: @escaping (CharacterResult) -> Void)
	func loadComics(by characterId: Int, _ completion: @escaping (ComicResult) -> Void)
}
typealias CharacterResult = Result<[Character]?, ServiceError>
typealias CharacterImageResult = Result<UIImage, ServiceError>
typealias ComicResult = Result<[Comic], ServiceError>
final class Repository: IRepository
{
	private let remoteDataService: IRemoteDataService

	init(remoteDataService: IRemoteDataService) {
		self.remoteDataService = remoteDataService
	}
	func loadCharacters(_ completion: @escaping (CharacterResult) -> Void){
		remoteDataService.loadCharacters { result in
			switch result {
			case .success(let data):
				do {
					let object = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
					let characters = object.data?.results
					completion(.success(characters))
				}
				catch {
					completion(.failure(.decodingError(error)))
				}
			case .failure(.browserError):
				completion(.failure(.browserError))
			default:
				break
			}
		}
	}
	func loadCharacterImage(for characterImage: Image,
							size: String,
							_ completion: @escaping (CharacterImageResult) -> Void) {
		remoteDataService.loadCharacterImage(for: characterImage, size: size) { result in
			switch result {
			case .success(let data):
				guard let image = UIImage(data: data) else {
					completion(.failure(.convertionImageError))
					return
				}
				completion(.success(image))
			case .failure(.browserError):
				completion(.failure(.browserError))
			default:
				break
			}
		}
	}
	func loadCharacter(by characterName: String, _ completion: @escaping (CharacterResult) -> Void) {
		remoteDataService.loadCharacter(by: characterName) { result in
			switch result {
			case .success(let result):
				do {
					let object = try JSONDecoder().decode(CharacterDataWrapper.self, from: result)
					let characters = object.data?.results
					completion(.success(characters))
				}
				catch {
					completion(.failure(.decodingError(error)))
				}
			case .failure(.browserError):
				completion(.failure(.browserError))
			default:
				break
			}
		}
	}
	func loadComics(by characterId: Int, _ completion: @escaping (ComicResult) -> Void) {
		remoteDataService.loadComics(by: characterId) { result in
			switch result {
			case .success(let result):
				do {
					let object = try JSONDecoder().decode(ComicDataWrapper.self, from: result)
					guard let comics = object.data?.results else {
						completion(.failure(.unvrapError))
						return
					}
					completion(.success(comics))
				}
				catch {
					completion(.failure(.decodingError(error)))
				}
			case .failure(.browserError):
				completion(.failure(.browserError))
			default:
				break
			}
		}
	}
}
