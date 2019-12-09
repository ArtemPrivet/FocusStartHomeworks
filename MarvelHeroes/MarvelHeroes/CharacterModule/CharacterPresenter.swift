//
//  CharacterPresenter.swift
//  MarvelHeroes
//
//  Created by MacBook Air on 04.12.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit

protocol ICharacterPresenter
{
	func getCharacters(name: String)
	func getCharacterImage(imageUrl: String, _ completion: @escaping (UIImage?) -> Void)
	func showDetail(of character: Character)
}

final class CharacterPresenter
{
	private var repository: ICharacterRepository
	private var router: ICharacterRouter
	weak var view: ICharacterViewController?
	private var characters = [Character]()

	init(repository: ICharacterRepository, router: ICharacterRouter) {
		self.repository = repository
		self.router = router
	}
}

extension CharacterPresenter: ICharacterPresenter
{
	func getCharacters(name: String) {
		repository.loadCharacter(name: name) { [weak self] result in
			switch result {
			case .success(let characters):
				DispatchQueue.main.async {
					self?.view?.show(characters)
				}
			case .failure(let error):
			assertionFailure(error.localizedDescription)
			}
		}
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

	func showDetail(of character: Character) {
		router.showDetail(of: character)
	}
}
