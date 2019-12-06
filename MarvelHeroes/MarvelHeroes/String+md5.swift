//
//  MD5.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import Foundation
import CommonCrypto
// Почему то на iOS < 13 приложение крашится при запуске с ошибкой
// Library not loaded: /System/Library/Frameworks/CryptoKit.framework/CryptoKit
// и нижеприведенный блок кода не помогает 🤷‍♂️🤷‍♂️🤷‍♂️
//#if canImport(CryptoKit)
//  import CryptoKit
//#endif

extension String
{
	var md5: String {
//		if #available(iOS 13.0, *) {
//			return Insecure
//				.MD5
//				.hash(data: data(using: .utf8) ?? Data())
//				.map { String(format: "%02hhx", $0) }
//				.joined()
//		}
//		else {
		let str = cString(using: .utf8)
		let strLen = CC_LONG(lengthOfBytes(using: .utf8))
		let digestLen = Int(CC_MD5_DIGEST_LENGTH)
		let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

		CC_MD5(str ?? [], strLen, result)

		let hash = NSMutableString()
		for index in 0..<digestLen {
			hash.appendFormat("%02x", result[index])
		}

		result.deinitialize(count: digestLen)

		return String(format: hash as String)
//		}
	}
}
