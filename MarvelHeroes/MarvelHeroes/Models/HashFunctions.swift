//
//  MD5.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation
import CommonCrypto

enum HashFunctions
{
	static func MD5(_ string: String) -> String? {
		let length = Int(CC_MD5_DIGEST_LENGTH)
		var digest = [UInt8](repeating: 0, count: length)
		if let data = string.data(using: .utf8) {
			_ = data.withUnsafeBytes { body -> String in
				CC_MD5(body.baseAddress, CC_LONG(data.count), &digest)
				return ""
			}
		}
		return (0..<length).reduce("") { $0 + String(format: "%02x", digest[$1]) }
	}
}
