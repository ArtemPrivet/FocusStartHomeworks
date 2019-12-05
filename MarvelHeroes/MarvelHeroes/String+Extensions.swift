//
//  String+Extensions.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG


extension String {
	
	func MD5() -> String {
		let length = Int(CC_MD5_DIGEST_LENGTH)
		let messageData = self.data(using:.utf8)!
		var digestData = Data(count: length)
		
		_ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
			messageData.withUnsafeBytes { messageBytes -> UInt8 in
				if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
					let messageLength = CC_LONG(messageData.count)
					CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
				}
				return 0
			}
		}
		return digestData.map { String(format: "%02hhx", $0) }.joined()
	}
	
	static func getUrlString (image: Image, variant: String) -> String {
		return "\(image.path)/\(variant).\(image.extension)"
	}
}

