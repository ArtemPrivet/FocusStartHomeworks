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
		let combinedHash = "\(Constants.timestamp)\(Constants.privateKey)\(Constants.publicKey)"
		return combinedHash.MD5()
	}
}

