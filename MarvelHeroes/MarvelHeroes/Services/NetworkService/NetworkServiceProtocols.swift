//
//  NetworkServiceProtocols.swift
//  
//
//  Created by Михаил Медведев on 26/07/2019.
//  Copyright © 2019 Михаил Медведев. All rights reserved.
//  swiftlint:disable function_parameter_count

import UIKit

protocol INetworkRequestable
{
	func request(to url: URL?,
				 type: RequestType,
				 headers: [String: String]?,
				 with data: Data?,
				 cancelsExitingDataTask: Bool,
				 responseHandler: @escaping (Result<Data, NetworkServiceError>) -> Void)
}

protocol IJSONDataFetchable
{
	func fetchJSONData<T: Decodable>(url: URL,
									 requestType: RequestType,
									 headers: [String: String]?,
									 completion: @escaping (Result<T, NetworkServiceError>) -> Void)
}

protocol IJSONDataSendable
{
	func sendJSONData<T: Codable>(url: URL,
								  with requestType: RequestType,
								  headers: [String: String]?,
								  using model: T,
								  response: @escaping (Result<[String: Any], NetworkServiceError>) -> Void)

	func sendJSONDataWithModelAsResponse<T: Codable, R: Decodable>(url: URL,
				   with requestType: RequestType,
				   headers: [String: String]?,
				   using model: T,
				   response: @escaping (Result<R, NetworkServiceError>) -> Void)
}
