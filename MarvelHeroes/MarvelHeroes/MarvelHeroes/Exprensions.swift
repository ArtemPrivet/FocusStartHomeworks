//
//  Exprensions.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 02.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
	var md5: String? {
		let length = Int(CC_MD5_DIGEST_LENGTH)
		var digest = [UInt8](repeating: 0, count: length)

		if let d = self.data(using: String.Encoding.utf8) {
			_ = d.withUnsafeBytes{ body in
				CC_MD5(body, CC_LONG(d.count), &digest)
			}
			/*_ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
				CC_MD5(body, CC_LONG(d.count), &digest)
			}*/
		}

		return (0..<length).reduce("") {
			$0 + String(format: "%02x", digest[$1])
		}
	}
}
