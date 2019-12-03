//
//  Repository.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 02.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation
protocol IRepository {
	func getCharacters(_ completion: @escaping (CharacterResult)-> Void)
	func getCharacterImage(for characterImage: CharacterImage, _ completion: @escaping (CharacterImageResult)-> Void)
}
final class Repository: IRepository
{

	private let remoteDataService: IRemoteDataService
	private var characters = [Character]()

	init(remoteDataService: IRemoteDataService) {
		self.remoteDataService = remoteDataService
	}
	func getCharacters(_ completion: @escaping (CharacterResult)-> Void){
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
	func getCharacterImage(for characterImage: CharacterImage, _ completion: @escaping (CharacterImageResult)-> Void) {
		remoteDataService.loadCharacterImage(for: characterImage) { result in
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
