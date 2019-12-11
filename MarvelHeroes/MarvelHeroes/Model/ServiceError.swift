//
//  ServiceError.swift
//  MarvelHeroes
//
//  Created by Антон on 07.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import Foundation

enum ServiceError: Error
{
	case noData
	case decode(Error)
	case session(Error)
	case wrongUrl
	case noHTTPResponse
	case clientError
	case serverError
}
