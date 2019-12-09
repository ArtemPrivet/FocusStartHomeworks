//
//  DetailPresenter.swift
//  MarvelHeroes
//
//  Created by MacBook Air on 06.12.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit

protocol IDetailPresenter
{
	func getCharacter() -> Character
	func getCharacterImage(imageUrl: String, _ completion: @escaping (UIImage?) -> Void)
}

final class DetailPresenter
{
	private var repository: ICharacterRepository
	private var character: Character

	init(repository: ICharacterRepository, character: Character) {
		self.repository = repository
		self.character = character
	}
}

extension DetailPresenter: IDetailPresenter
{
	func getCharacter() -> Character {
		return character
	}

	func getCharacterImage(imageUrl: String, _ completion: @escaping (UIImage?) -> Void) {
		repository.loadImage(imageUrl: imageUrl) { imageResult in
			switch imageResult {
			case .success(let image):
				DispatchQueue.main.async {
					completion(image)
				}
			case .failure(let error):
			assertionFailure(error.localizedDescription)
			}
		}
	}
}
