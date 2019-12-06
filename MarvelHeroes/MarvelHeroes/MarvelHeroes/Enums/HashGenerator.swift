//
//  HashGenerator.swift
//  MarvelHeroes
//
//  Created by Саша Руцман on 06/12/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation

enum HashGenerator
{
	static func generateHash() -> String {
		let combinedHash = "\(Constants.timestamp)\(Constants.privateKey)\(Constants.publicKey)"
		return combinedHash.MD5()
	}
}
