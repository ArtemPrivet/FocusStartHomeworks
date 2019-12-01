//
//  HashGenerator.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

class HashGenerator {
	
	static func generateHash() -> String {
		let combinedHash = "\(Constans.timestamp)\(Constans.privateKey)\(Constans.publicKey)"
		return combinedHash.MD5()
	}
}

