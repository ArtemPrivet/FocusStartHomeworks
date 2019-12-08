//
//  ServiceErrors.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/9/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

enum ServiceError: Error
{
	case noData
	case invalidURL(Error)
	case noResponse
}
