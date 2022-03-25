//
//  DateFormatter+Helper.swift
//  BC
//
//  Created by Nikolay on 03.01.2022.
//

import Foundation

extension DateFormatter {
	static var bondDateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter
	}()
}
