//
//  Bond.swift
//  BC
//
//  Created by Nikolay on 02.01.2022.
//

import Foundation

struct Response: Decodable {
	let rates: Rates
}

struct Rates: Decodable {
	let columns: Array<String>
	let data: Array<Array<Datum>>
}

enum Datum: Decodable {
	case double(Double)
	case string(String)
	case null

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let x = try? container.decode(Double.self) {
			self = .double(x)
			return
		}
		if let x = try? container.decode(String.self) {
			self = .string(x)
			return
		}
		if container.decodeNil() {
			self = .null
			return
		}
		throw DecodingError.typeMismatch(Datum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Datum"))
	}
}

struct Bond {

	private struct BondKeys {
		static let secId = "SECID"
		static let shortName = "SHORTNAME"
		static let name = "NAME"
//		static let typeName = "TYPENAME"
		static let isin = "ISIN"
//		static let regNumber = "REGNUMBER"
//		static let listLevel = "LISTLEVEL"
		static let faceValue = "FACEVALUE"
		static let faceUnit = "FACEUNIT"
//		static let issueSize = "ISSUESIZE"
//		static let isCollateral = "IS_COLLATERAL"
//		static let isExternal = "IS_EXTERNAL"
//		static let primaryBoardId = "PRIMARY_BOARDID"
//		static let primaryBoardTitle = "PRIMARY_BOARD_TITLE"
		static let matDate = "MATDATE"
//		static let isRii = "IS_RII"
//		static let eveningSession = "EVENINGSESSION"
//		static let morningSession = "MORNINGSESSION"
//		static let duration = "DURATION"
		static let isQualifiedInvestors = "IS_QUALIFIED_INVESTORS"
		static let highRisk = "HIGH_RISK"
//		static let couponFrequency = "COUPONFREQUENCY"
//		static let yieldAtWap = "YIELDATWAP"
//		static let couponDate = "COUPONDATE"
//		static let couponPercent = "COUPONPERCENT"
		static let couponValue = "COUPONVALUE"
		static let couponDaysPassed = "COUPONDAYSPASSED"
//		static let couponDaysRemain = "COUPONDAYSREMAIN"
		static let couponLength = "COUPONLENGTH"
//		static let issueDate = "ISSUEDATE"
//		static let initialFaceValue = "INITIALFACEVALUE"
//		static let secSubtype = "SECSUBTYPE"
//		static let startDateMoex = "STARTDATEMOEX"
		static let dayStoredEmption = "DAYSTOREDEMPTION"
//		static let offerDate = "OFFERDATE"
//		static let emitentName = "EMITENTNAME"
//		static let inn = "INN"
//		static let lotsize = "LOTSIZE"
		static let price = "PRICE"
//		static let priceRub = "PRICE_RUB"
//		static let rtl1 = "RTL1"
//		static let rth1 = "RTH1"
//		static let rtl2 = "RTL2"
//		static let rth2 = "RTH2"
//		static let rtl3 = "RTL3"
//		static let rth3 = "RTH3"
//		static let discount1 = "DISCOUNT1"
//		static let limit1 = "LIMIT1"
//		static let discount2 = "DISCOUNT2"
//		static let limit2 = "LIMIT2"
//		static let discount3 = "DISCOUNT3"
//		static let discountl0 = "DISCOUNTL0"
//		static let discounth0 = "DISCOUNTH0"
	}

	// MARK: - Properties

	let secId: String
	let shortName: String
	let name: String
//	let typeName: String
	let isin: String
//	let regNumber: String?
//	let listLevel: Int?
	let faceValue: Double
	let faceUnit: String
//	let issueSize: Int
//	let isCollateral: Bool
//	let isExternal: Bool
//	let primaryBoardId: String
//	let primaryBoardTitle: String
	let matDate: Date?
//	let isRii: String?
//	let eveningSession: Bool
//	let morningSession: Bool
//	let duration: Int
	let isQualifiedInvestors: Bool
	let isHighRisk: Bool
//	let couponFrequency: Int
//	let yieldAtWap: String?
//	let couponDate: Date
//	let couponPercent: Double?
	let couponValue: Double
	let couponDaysPassed: Double
//	let couponDaysRemain: Int?
	let couponLength: Double
//	let issueDate: Date
//	let initialFaceValue: Double?
//	let secSubtype: String?
//	let startDateMoex: Date?
	let dayStoredEmption: Int
//	let offerDate: Date?
//	let emitentName: String
//	let inn: String
//	let lotsize: Int
	let percentagePrice: Double?
//	let priceRub: Double?
//	let rtl1: Double?
//	let rth1: Double?
//	let rtl2: Double?
//	let rth2: Double?
//	let rtl3: Double?
//	let rth3: Double?
//	let discount1: Double?
//	let limit1: Double?
//	let discount2: Double?
//	let limit2: Double?
//	let discount3: Double?
//	let discountl0: Double?
//	let discounth0: Double?

	let couponCount: Int
	let realPercentIncomePerYear: Double?

	// MARK: - Initializers

	init?(keys: [String], values: [Datum]) {
		let anyValues: [Any?] = values.map {
			switch $0 {
			case .string(let value):
				return value
			case .double(let value):
				return value
			case .null:
				return nil
			}
		}

		let dictionary = Dictionary(uniqueKeysWithValues: (zip(keys, anyValues)))
		guard let secId = dictionary[BondKeys.secId] as? String,
			  let shortName = dictionary[BondKeys.shortName] as? String,
			  let name = dictionary[BondKeys.name] as? String,
			  let isin = dictionary[BondKeys.isin] as? String,
			  let faceValue = dictionary[BondKeys.faceValue] as? Double,
			  let faceUnit = dictionary[BondKeys.faceUnit] as? String,
			  let couponValue = dictionary[BondKeys.couponValue] as? Double,
			  let couponDaysPassed = dictionary[BondKeys.couponDaysPassed] as? Double,
			  let couponLength = dictionary[BondKeys.couponLength] as? Double,
			  let dayStoredEmption = dictionary[BondKeys.dayStoredEmption] as? Double
		else {
				return nil
		}

		self.secId = secId
		self.shortName = shortName
		self.name = name
		self.isin = isin
		self.faceValue = faceValue
		self.faceUnit = faceUnit
		self.matDate = DateFormatter.bondDateFormatter.date(from: dictionary[BondKeys.matDate] as? String ?? "")
		self.isQualifiedInvestors = dictionary[BondKeys.isQualifiedInvestors] as? Double == 1
		self.isHighRisk = dictionary[BondKeys.highRisk] as? Double == 1
		self.couponValue = couponValue
		self.couponDaysPassed = couponDaysPassed
		self.couponLength = couponLength
		self.dayStoredEmption = Int(dayStoredEmption)
		self.percentagePrice = dictionary[BondKeys.price] as? Double

		if couponLength > 0 {
			let couponCount = Int(Double(dayStoredEmption) / couponLength)
			self.couponCount = couponCount <= 0 ? 1 : couponCount
		} else {
			self.couponCount = 0
		}

		if couponLength > 0, let percentagePrice = percentagePrice {
			let price = percentagePrice * faceValue / 100
			let сouponIncome = (couponValue - 13 * couponValue / 100) * Double(couponCount)
			let netIncome = сouponIncome - (price - faceValue) - couponValue * couponDaysPassed / couponLength
			let incomePerDay = netIncome / Double(dayStoredEmption)
			let incomePerYear = incomePerDay * 365
			self.realPercentIncomePerYear = incomePerYear * 100 / price
		} else {
			self.realPercentIncomePerYear = nil
		}

	}
}

// MARK: - Identifiable
extension Bond: Identifiable {
	var id: String {
		return isin
	}
}

// MARK: - Hashable
extension Bond: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(isin)
	}

	static func == (lhs: Bond, rhs: Bond) -> Bool {
		return lhs.isin == rhs.isin
	}
}

struct BondDetail {

}
