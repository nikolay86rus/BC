//
//  FiltersSelectView.swift
//  BC
//
//  Created by Nikolay on 08.01.2022.
//

import SwiftUI

struct FiltersSelectView: View {

	@StateObject var viewModel: FiltersViewModel
	let onUpdateCompletion: (() -> Void)

	private let backgroundColor = Color(#colorLiteral(red: 0.9135745168, green: 0.9140088558, blue: 0.9172110558, alpha: 1))

	var body: some View {
		Form {
			HStack {
				Text("Название: ")
				TextField("", text: $viewModel.filters.name)
			}
			Toggle("Для квалифицированных инвесторов", isOn: $viewModel.filters.isQualifiedInvestors)
			Toggle("С высоким риском", isOn: $viewModel.filters.isHighRisk)
			HStack {
				Text("Валюты:")
				Spacer()
				CurrenciesPicker(currencyFilters: $viewModel.filters.currencyFilters).frame(alignment: .trailing)
			}
			HStack {
				Text("Количество купонов, шт")
				Spacer()
				TextField("мин", text: $viewModel.filters.minCouponsCount)
					.onReceive(viewModel.filters.minCouponsCount.publisher.collect()) {
						self.viewModel.filters.minCouponsCount = String($0.prefix(3))
					}
					.keyboardType(.decimalPad)
					.background(RoundedRectangle(cornerRadius: 4).fill(backgroundColor))
					.multilineTextAlignment(.center)
					.frame(width: 44)

				TextField("макс", text: $viewModel.filters.maxCouponsCount)
					.onReceive(viewModel.filters.maxCouponsCount.publisher.collect()) {
						self.viewModel.filters.maxCouponsCount = String($0.prefix(3))
					}
					.keyboardType(.decimalPad)
					.background(RoundedRectangle(cornerRadius: 4).fill(backgroundColor))
					.multilineTextAlignment(.center)
					.frame(width: 44)
			}
			HStack {
				Text("Доходность, %")
				Spacer()
				TextField("мин", text: $viewModel.filters.minIncomePercent)
					.onReceive(viewModel.filters.minIncomePercent.publisher.collect()) {
						self.viewModel.filters.minIncomePercent = String($0.prefix(4))
					}
					.keyboardType(.decimalPad)
					.background(RoundedRectangle(cornerRadius: 4).fill(backgroundColor))
					.multilineTextAlignment(.center)
					.frame(width: 56)

				TextField("макс", text: $viewModel.filters.maxIncomePercent)
					.onReceive(viewModel.filters.maxIncomePercent.publisher.collect()) {
						self.viewModel.filters.maxIncomePercent = String($0.prefix(4))
					}
					.keyboardType(.decimalPad)
					.background(RoundedRectangle(cornerRadius: 4).fill(backgroundColor))
					.multilineTextAlignment(.center)
					.frame(width: 56)
			}
			HStack {
				Text("Номинал")
				Spacer()
				TextField("мин", text: $viewModel.filters.minNominal)
					.onReceive(viewModel.filters.minNominal.publisher.collect()) {
						self.viewModel.filters.minNominal = String($0.prefix(4))
					}
					.keyboardType(.decimalPad)
					.background(RoundedRectangle(cornerRadius: 4).fill(backgroundColor))
					.multilineTextAlignment(.center)
					.frame(width: 56)

				TextField("макс", text: $viewModel.filters.maxNominal)
					.onReceive(viewModel.filters.maxNominal.publisher.collect()) {
						self.viewModel.filters.maxNominal = String($0.prefix(4))
					}
					.keyboardType(.decimalPad)
					.background(RoundedRectangle(cornerRadius: 4).fill(backgroundColor))
					.multilineTextAlignment(.center)
					.frame(width: 56)
			}

			DatePicker(selection: $viewModel.filters.matDateFrom, displayedComponents: [.date]) {
				Text("Дата погашения c")
			}
			.accentColor(.primary)

			DatePicker(selection: $viewModel.filters.matDateTo, displayedComponents: [.date]) {
				Text("Дата погашения по")
			}
			.accentColor(.primary)
		}
		.onDisappear {
			onUpdateCompletion()
		}
		.navigationBarTitle(Text("Фильтры"), displayMode: .inline)
	}
}

struct CurrencyFilter: Hashable {
	let currencyCode: String
	var isActive = true

	func hash(into hasher: inout Hasher) {
		hasher.combine(currencyCode)
	}
}

struct CurrenciesPicker: View {

	@Binding var currencyFilters: [CurrencyFilter]

	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack {
				ForEach(0..<currencyFilters.count) { index in
					CurrencyButton(title: currencyFilters[index].currencyCode, isSelected: $currencyFilters[index].isActive)
				}
			}
		}
	}
}

struct CurrencyButton: View {

	let title: String
	@Binding var isSelected: Bool

	private let backgroundColor = Color(#colorLiteral(red: 0.9135745168, green: 0.9140088558, blue: 0.9172110558, alpha: 1))
	private let textColor = Color(#colorLiteral(red: 0.7095984221, green: 0.7103105187, blue: 0.7169095278, alpha: 1))

	var body: some View {
		Text(title)
			.frame(width: 44)
			.background(
				RoundedRectangle(cornerRadius: 4).fill(isSelected ? .blue : backgroundColor)
			)
			.foregroundColor(isSelected ? .white : textColor)
			.onTapGesture {
				isSelected.toggle()
			}
	}
}

//struct CurrencyButton_Previews: PreviewProvider {
//	static var previews: some View {
//		CurrencyButton(title: "RUB", isSelected: .constant(true))
//	}
//}

struct NameTextField: View {

	@Binding var name: String

	var body: some View {
		HStack {
			Text("Название: ")
			Spacer()
			TextField("", text: $name)
		}
	}
}

struct NameTextField_Previews: PreviewProvider {
	static var previews: some View {
		NameTextField(name: .constant(""))
	}
}
