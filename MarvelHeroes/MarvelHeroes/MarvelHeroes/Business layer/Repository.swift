//
//  Repository.swift
//  MarvelHeroes
//
//  Created by Саша Руцман on 04/12/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import UIKit

typealias CharactersResult = Result<CharacterDataWrapper, ServiceError>
typealias DataResult = Result<Data, ServiceError>
typealias ImageResult = Result<UIImage, ServiceError>
typealias ComicsResult = Result<ComicsDataWrapper, ServiceError>

protocol IRepository
{
	func loadCharacters(called: String?, url: URL, _ completion: @escaping (CharactersResult) -> Void)
	func loadImage(hero: Character, quality: String, _ completion: @escaping (ImageResult) -> Void)
}

final class Repository
{
	private let decoder = JSONDecoder()
	private var dataTask: URLSessionDataTask?

	private func fetchData(from url: URL, _ completion: @escaping(DataResult) -> Void) {
		let task = URLSession.shared.dataTask(with: url) { data, _, error in
			if let newError = error {
				completion(.failure(.sessionError(newError)))
				return
			}
			if let data = data {
				completion(.success(data))
			}
		}
		task.resume()
	}
}

extension Repository: IRepository
{
	func loadCharacters(called: String?, url: URL, _ completion: @escaping (CharactersResult) -> Void) {
		fetchData(from: url) { dataResult in
			switch dataResult {
			case .success(let data):
				do {
					let characters = try self.decoder.decode(CharacterDataWrapper.self, from: data)
					completion(.success(characters))
				}
				catch {
					completion(.failure(ServiceError.dataError(error)))
					return
				}
			case .failure(let error):
				completion(.failure(error))
				print(error.localizedDescription)
			}
		}
	}

	func loadComics(called: String?, url: URL, _ completion: @escaping (ComicsResult) -> Void) {
		fetchData(from: url) { dataResult in
			switch dataResult {
			case .success(let data):
				do {
					let comics = try self.decoder.decode(ComicsDataWrapper.self, from: data)
					completion(.success(comics))
				}
				catch {
					completion(.failure(ServiceError.dataError(error)))
					return
				}
			case .failure(let error):
				completion(.failure(error))
				print(error.localizedDescription)
			}
		}
	}

	func loadImage(hero: Character, quality: String, _ completion: @escaping (ImageResult) -> Void) {
		let urlString = "\(hero.thumbnail.path)/\(quality).\(hero.thumbnail.extension)"
		if let url = URL(string: urlString) {
			fetchData(from: url) { imageResult in
				switch imageResult {
				case .success(let data):
					guard let image = UIImage(data: data) else { return }
					completion(.success(image))
				case .failure(let error):
					completion(.failure(error))
				}
			}
		}
	}

	func loadComicsImage(comics: Comics, quality: String, _ completion: @escaping (ImageResult) -> Void) {
		let urlString = "\(comics.thumbnail.path)/\(quality).\(comics.thumbnail.extension)"
		if let url = URL(string: urlString) {
			fetchData(from: url) { imageResult in
				switch imageResult {
				case .success(let data):
					guard let image = UIImage(data: data) else { return }
					completion(.success(image))
				case .failure(let error):
					completion(.failure(error))
				}
			}
		}
	}
}
