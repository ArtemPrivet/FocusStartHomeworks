//
//  RequestType.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 01.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import Foundation

enum RequestType: String
{
	case get = "GET"
	case post = "POST"
	case delete = "DELETE"
	case put = "PUT"
	case update = "UPDATE"
	case patch = "PATCH"
}
