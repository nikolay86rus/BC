//
//  BondListViewModel.swift
//  BC
//
//  Created by Nikolay on 15.01.2022.
//

import Foundation

protocol FiltersProviderProtocol {

}

protocol BondsProviderProtocol {
	func getBonds(completion: @escaping ([Bond]) -> ())
}

class BondListViewModel: ObservableObject {

	// MARK: - Properties

	@Published var bonds: [Bond] = []
	var filters = Filters()

	// MARK: - Private properties

	private let bondsProvider: BondsProviderProtocol
	private var responseBonds: [Bond] = [] {
		didSet {
			updateAvailableCurrencies()
			updateAvailableDateInterval()
		}
	}

	// MARK: - Initializers

	init(bondsProvider: BondsProviderProtocol) {
		self.bondsProvider = bondsProvider
		fetchBonds()
	}

	// MARK: - Functions

	func fetchBonds() {
		bondsProvider.getBonds { [weak self] (response) in
			self?.responseBonds = response.sorted(by: { $0.dayStoredEmption < $1.dayStoredEmption })
			self?.applyFilters()
		}
	}

	func applyFilters() {
		bonds = responseBonds.filter { (bond) -> Bool in

			if !filters.name.isEmpty, !bond.name.localizedCaseInsensitiveContains(filters.name) {
				return false
			}

			if !filters.isQualifiedInvestors, bond.isQualifiedInvestors {
				return false
			}

			if !filters.isHighRisk, bond.isHighRisk {
				return false
			}

			if !filters.currencyFilters.isEmpty,
			   !filters.currencyFilters.contains(where: { $0.currencyCode == bond.faceUnit && $0.isActive }) {
				return false
			}

			if let minIncomePercent = Int(filters.minCouponsCount), bond.couponCount < minIncomePercent {
				return false
			}

			if let maxCouponsCount = Int(filters.maxCouponsCount), bond.couponCount > maxCouponsCount {
				return false
			}

			if let minNominal = Double(filters.minNominal), bond.faceValue < minNominal {
				return false
			}

			if let maxNominal = Double(filters.maxNominal), bond.faceValue > maxNominal {
				return false
			}

			if let minIncomePercent = NumberFormatter.percentIncomeFormatter.number(from: filters.minIncomePercent) {
				if bond.realPercentIncomePerYear == nil {
					return false
				}

				if let realPercentIncomePerYear = bond.realPercentIncomePerYear,
				   realPercentIncomePerYear < minIncomePercent.doubleValue {
					return false
				}
			}

			if let maxIncomePercent = NumberFormatter.percentIncomeFormatter.number(from: filters.maxIncomePercent) {
				if bond.realPercentIncomePerYear == nil {
					return false
				}

				if let realPercentIncomePerYear = bond.realPercentIncomePerYear,
				   realPercentIncomePerYear > maxIncomePercent.doubleValue {
					return false
				}
			}

			if let matDate = bond.matDate,
			   matDate < filters.matDateFrom {
				return false
			}

			if let matDate = bond.matDate,
			   matDate > filters.matDateTo {
				return false
			}

			return true
		}
	}

	private func updateAvailableCurrencies() {
		filters.currencyFilters = responseBonds.reduce(into: Set<String>()) {
			$0.insert($1.faceUnit)
		}.map {
			CurrencyFilter(currencyCode: $0)
		}
	}

	private func updateAvailableDateInterval() {
		if let earliestDate = responseBonds.first?.matDate {
			filters.matDateFrom = earliestDate
		}
		if let latestDate = responseBonds.last?.matDate {
			filters.matDateTo = latestDate
		}
	}

}
