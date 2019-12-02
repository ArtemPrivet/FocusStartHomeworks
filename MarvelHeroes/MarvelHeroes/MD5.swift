//
//  MD5.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import Foundation
import CryptoKit

func MD5(_ string: String) -> String {
	Insecure
		.MD5
		.hash(data: string.data(using: .utf8) ?? Data())
		.map { String(format: "%02hhx", $0) }
		.joined()
}
