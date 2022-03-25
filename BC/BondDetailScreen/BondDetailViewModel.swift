//
//  BondDetailViewModel.swift
//  BC
//
//  Created by Nikolay on 16.01.2022.
//

import Foundation

protocol BondDetailProviderProtocol {
	func getDetail(for bondSecId: String, completion: @escaping (BondDetail) -> Void)
}

class BondDetailViewModel: ObservableObject {

	// MARK: - Properties

	let bond: Bond
	@Published var bondDetail: BondDetail?
	var price = "" {
		didSet {
			if price != oldValue {
				updatePercentIncomePerYear()
			}
		}
	}
	@Published var percentIncomePerYear: Double?

	// MARK: - Private properties

	private let bondDetailProvider: BondDetailProviderProtocol

	// MARK: - Initializers

	init(bondDetailProvider: BondDetailProviderProtocol, bond: Bond) {
		self.bondDetailProvider = bondDetailProvider
		self.bond = bond
		bondDetailProvider.getDetail(for: bond.secId) { [weak self] in
			self?.bondDetail = $0
		}
	}

	// MARK: - Private functions

	private func updatePercentIncomePerYear() {
		guard let price = NumberFormatter.percentIncomeFormatter.number(from: price)?.doubleValue else {
			return
		}

		let сouponIncome = (bond.couponValue - 13 * bond.couponValue / 100) * Double(bond.couponCount)
		let netIncome = сouponIncome - (price - bond.faceValue) - bond.couponValue * bond.couponDaysPassed / bond.couponLength
		let incomePerDay = netIncome / Double(bond.dayStoredEmption)
		let incomePerYear = incomePerDay * 365
		percentIncomePerYear = incomePerYear * 100 / price
	}
}
