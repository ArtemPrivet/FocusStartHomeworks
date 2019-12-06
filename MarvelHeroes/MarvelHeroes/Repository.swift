//
//  Repository.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 02.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation
protocol IRepository
{
	func loadCharacters(_ completion: @escaping (CharacterResult) -> Void)
	func loadCharacterImage(for characterImage: Image,
							size: String,
							_ completion: @escaping (CharacterImageResult) -> Void)
	func loadCharacter(by characterName: String, _ completion: @escaping (CharacterResult) -> Void)
	func loadComics(by characterId: Int, _ completion: @escaping (ComicResult) -> Void)
}
final class Repository: IRepository
{

	private let remoteDataService: IRemoteDataService

	init(remoteDataService: IRemoteDataService) {
		self.remoteDataService = remoteDataService
	}
	func loadCharacters(_ completion: @escaping (CharacterResult) -> Void){
		remoteDataService.loadCharacters { result in
			switch result {
			case .success(let result):
				completion(.success(result))
			case .failure(.browserError):
				break
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
			case .success(let result):
				completion(.success(result))
			case .failure(.browserError):
				break
			default:
				break
			}
		}
	}
	func loadCharacter(by characterName: String, _ completion: @escaping (CharacterResult) -> Void) {
		remoteDataService.loadCharacter(by: characterName) { result in
			switch result {
			case .success(let result):
				completion(.success(result))
			case .failure(.browserError):
				break
			default:
				break
			}
		}
	}
	func loadComics(by characterId: Int, _ completion: @escaping (ComicResult) -> Void) {
		remoteDataService.loadComics(by: characterId) { result in
			switch result {
			case .success(let result):
				completion(.success(result))
			case .failure(.browserError):
				break
			default:
				break
			}
		}
	}
}
