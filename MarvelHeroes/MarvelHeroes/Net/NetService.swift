//
//  NetService.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/1/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit
import CommonCrypto

typealias HeroResult = Result<HeroesByID, ServiceError>
typealias ComicResult = Result<ComicsByID, ServiceError>
typealias HeroImageResult = Result<UIImage, ServiceError>
final class NetService
{
	private let decoder = JSONDecoder()
	private let session = URLSession(configuration: .default)
	private var dataTask: URLSessionDataTask?
	private let hashString: String
	private let tsItem: URLQueryItem
	private let apiKeiItem: URLQueryItem
	private let hashItem: URLQueryItem

	init() {
		hashString = Constant.ts + Constant.privateKey + Constant.publicKey
		tsItem = URLQueryItem(name: "ts", value: Constant.ts)
		apiKeiItem = URLQueryItem(name: "apikey", value: Constant.publicKey)
		hashItem = URLQueryItem(name: "hash", value: hashString.md5)
	}

	func loadHeroes(_ text: String, completion: @escaping (HeroResult) -> Void) {
		if var urlComponents = URLComponents(string: Constant.starttURL + Constant.characters){
			let textQuery = URLQueryItem(name: "nameStartsWith", value: text)
			urlComponents.queryItems = [textQuery, apiKeiItem, tsItem, hashItem]
			if let url = urlComponents.url {
				dataTask = session.dataTask(with: url) { data, _, error in
					if let error = error {
						completion(.failure(.invalidURL(error)))
						return
					}
					if let data = data {
						do {
							let object = try self.decoder.decode(HeroesByID.self, from: data)
							DispatchQueue.main.async {
								completion(.success(object))
							}
						}
						catch {
							DispatchQueue.main.async {
								completion(.failure(.noData))
							}
						}
					}
					else {
						completion(.failure(.noResponse))
					}
				}
				dataTask?.resume()
			}
		}
	}

	func loadComics(_ heroID: Int, completion: @escaping (ComicResult) -> Void) {

		if var urlComponents = URLComponents(string: "https://gateway.marvel.com/v1/public/characters/\(heroID)/comics"){
			urlComponents.query = "&ts=\(Constant.ts)&apikey=\(Constant.publicKey)&hash=\(hashString.md5)"
			if let url = urlComponents.url {
				dataTask = session.dataTask(with: url) { data, _, error in
					if let error = error {
						completion(.failure(.invalidURL(error)))
						return
					}
					if let data = data {
						do {
							let object = try self.decoder.decode(ComicsByID.self, from: data)
							DispatchQueue.main.async {
								completion(.success(object))
							}
						}
						catch {
							DispatchQueue.main.async {
								completion(.failure(.noData))
							}
						}
					}
					else {
						completion(.failure(.noResponse))
					}
				}
				dataTask?.resume()
			}
		}
	}
}

extension String
{
	var md5: String {
		let data = Data(self.utf8)
		let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
			var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
			CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
			return hash
		}
		return hash.map { String(format: "%02x", $0) }.joined()
	}
}
