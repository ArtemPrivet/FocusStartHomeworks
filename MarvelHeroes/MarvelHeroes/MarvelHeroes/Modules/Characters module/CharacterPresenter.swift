//
//  CharacterPresenter.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import UIKit

protocol ICharactersPresenter {
	func performLoadCharacters(after time: TimeInterval, with string: String)
//	func loadImage(from path: String, extension: String, _ completion: @escaping (UIImage?) -> Void)
	func onThumnailUpdate(by path: String, extension: String, _ completion: @escaping (UIImage?) -> Void)
}

class CharactersPresenter {

	private var repository: ICharactersRepository & IImagesRepository
	private var router: ICharactersRouter

	weak var view: ICharacterListViewController?

	init(repository: ICharactersRepository & IImagesRepository, router: ICharactersRouter) {
		self.repository = repository
		self.router = router
	}

	private var pendingRequesrWorkItem: DispatchWorkItem?

	private func perform(after: TimeInterval, _ block: @escaping () -> Void) {
		pendingRequesrWorkItem?.cancel()

		let requestWorkItem = DispatchWorkItem(block: block)

		pendingRequesrWorkItem = requestWorkItem

		DispatchQueue.main.asyncAfter(deadline: .now() + after,
									  execute: requestWorkItem)
	}
}

extension CharactersPresenter: ICharactersPresenter {

	func performLoadCharacters(after time: TimeInterval = 0.5, with string: String) {

		perform(after: time) { [weak self] in

			self?.repository.fetchCharacters(name: string) { result in
				switch result {
				case .success(let characters):
					DispatchQueue.main.async {
						self?.view?.showCharacters(characters)
					}
				case .failure:
					DispatchQueue.main.async {
						self?.view?.showAlert()
					}
				}
			}
		}
	}

	func loadImage(from path: String, extension: String, _ completion: @escaping (UIImage?) -> Void) {
		repository.fetchImage(from: path, extension: `extension`) { result in
			switch result {
			case .success(let image):
				DispatchQueue.main.async {
					completion(image)
				}
			case .failure:
				DispatchQueue.main.async {
					completion(nil)
				}
			}
		}
	}

	func onThumnailUpdate(by path: String, extension: String, _ completion: @escaping (UIImage?) -> Void) {
		DispatchQueue(label: "com.ImageLoad", qos: .utility, attributes: .concurrent).async { [weak self] in
			self?.repository.fetchImage(from: path, extension: `extension`) { result in
				switch result {
				case .success(let image):
					DispatchQueue.main.async {
						completion(image)
					}
				case .failure:
					DispatchQueue.main.async {
						completion(nil)
					}
				}
			}
		}
	}
}
