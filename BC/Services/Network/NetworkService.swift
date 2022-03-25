//
//  NetworkService.swift
//  BC
//
//  Created by Nikolay on 03.01.2022.
//

import Foundation

class NetworkService: BondsProviderProtocol, BondDetailProviderProtocol {

	private let jsonQueries = "iss.json=compact&iss.meta=off"

	func getBonds(completion: @escaping ([Bond]) -> Void) {
		guard let url = URL(string: "https://iss.moex.com/iss/apps/infogrid/emission/rates.json?limit=unlimited&\(jsonQueries)") else {
			return
		}

		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let error = error {
				print("Request error: ", error)
				return
			}

			guard let httpResponse = response as? HTTPURLResponse,
				  httpResponse.statusCode == 200,
				  let data = data else {
				print("Response error: ", response)
				return
			}

			print(data.prettyPrintedJSONString)

			let response = try? JSONDecoder().decode(Response.self, from: data)
			guard let keys = response?.rates.columns, let bondsData = response?.rates.data else {
				print("Response decode error: ", response)
				return
			}

			DispatchQueue.main.async {
				completion(bondsData.compactMap { Bond(keys: keys, values: $0) })
			}
		}.resume()
	}

	func getDetail(for bondSecId: String, completion: @escaping (BondDetail) -> Void) {
		guard let url = URL(string: "https://iss.moex.com/iss/statistics/engines/stock/markets/bonds/bondization/\(bondSecId).json?\(jsonQueries)") else {
			return
		}

		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let error = error {
				print("Request error: ", error)
				return
			}

			guard let httpResponse = response as? HTTPURLResponse,
				  httpResponse.statusCode == 200,
				  let data = data else {
				print("Response error: ", response)
				return
			}

			DispatchQueue.main.async {
				
			}
		}
	}
}
