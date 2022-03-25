//
//  FiltersViewModel.swift
//  BC
//
//  Created by Nikolay on 15.01.2022.
//

import Foundation

class Filters: ObservableObject {
	var name = ""
	var isQualifiedInvestors = true
	var isHighRisk = true
	var currencyFilters: [CurrencyFilter] = []
	var minCouponsCount = ""
	var maxCouponsCount = ""
	var minIncomePercent = ""
	var maxIncomePercent = ""
	var minNominal = ""
	var maxNominal = ""
	var matDateFrom = Date()
	var matDateTo = Date.distantFuture
}

class FiltersViewModel: ObservableObject {

	// MARK: - Properties

	@Published var filters: Filters

	// MARK: - Initializers

	init(filters: Filters) {
		self.filters = filters
	}
}
