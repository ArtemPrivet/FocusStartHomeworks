//
//  NetService.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/1/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation
import CommonCrypto

final class NetService
{

	private let decoder = JSONDecoder()
	private let session = URLSession(configuration: .default)
	private var dataTask: URLSessionDataTask?
	private let privateKey = "9e68d35d9836c3fb0bc2da77194dd8b87397b242"
	private let publicKey = "caf6bca75564581b07d4dd518cb4626c"
	private let ts = "1"
	private var hashString: String {
		return ts + privateKey + publicKey
	}
	typealias DataResult = Result<HeroesByID, NSError>

	func loadHeroes(_ text: String, completion: @escaping (DataResult) -> Void) {

		if var urlComponents = URLComponents(string: "https://gateway.marvel.com/v1/public/characters"){
			urlComponents.query = "nameStartsWith=\(text)&ts=\(ts)&apikey=\(publicKey)&hash=\(hashString.md5)"
			if let url = urlComponents.url {
				dataTask = session.dataTask(with: url) { (data, _, error) in
					if let data = data {
						do {
							let object = try self.decoder.decode(HeroesByID.self, from: data)
							DispatchQueue.main.async {
								completion(.success(object))
							}
						} catch {
							DispatchQueue.main.async {
								completion(.failure(error as NSError))
							}
						}
					}
				}
				dataTask?.resume()
			}
		}
	}
}

extension String {
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
