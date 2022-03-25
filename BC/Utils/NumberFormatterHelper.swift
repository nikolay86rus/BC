//
//  NumberFormatterHelper.swift
//  BC
//
//  Created by Nikolay on 20.01.2022.
//

import Foundation

extension NumberFormatter {
	static let percentIncomeFormatter: NumberFormatter = {
		let numberFormatter = NumberFormatter()
		numberFormatter.decimalSeparator = ","
		
		return numberFormatter
	}()
}
