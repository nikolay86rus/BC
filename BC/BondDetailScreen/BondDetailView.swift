//
//  BondDetailView.swift
//  BC
//
//  Created by Nikolay on 03.01.2022.
//

import SwiftUI

struct BondDetailView: View {

	@StateObject var viewModel: BondDetailViewModel

	var body: some View {
		VStack {
			Form {
				BondDetailRow(description: "ISIN", descriptionValue: viewModel.bond.isin)
				BondDetailRow(description: "Имя", descriptionValue: viewModel.bond.name)
				HStack {
					Text("Номинал:")
					Spacer()
					Text("\(String(format: "%.2f", viewModel.bond.faceValue)) \(viewModel.bond.faceUnit)")
				}
				VStack {
					HStack {
						Text("Цена на бирже:")
						Spacer()
						TextField("0.0", text: $viewModel.price)
							.keyboardType(.decimalPad)
					}
					HStack {
						Text("Расчётная доходность:")
						Spacer()
						if let percentIncomePerYear = viewModel.percentIncomePerYear {
							Text("\(String(format: "%.2f", percentIncomePerYear))%")
						}
					}
				}
				if let url = URL(string: "https://smart-lab.ru/q/bonds/\(viewModel.bond.isin)") {
					Link("smar-lab.ru", destination: url)
				}
			}
			Spacer()
		}
		.onTapGesture {
			UIApplication.shared.endEditing()
		}
	}
}

struct BondDetailRow: View {

	let description: String
	let descriptionValue: String

	@State private var showAlert = false

	var body: some View {
		HStack {
			Text("\(description):")
				.layoutPriority(100)
			Spacer()
			Text(descriptionValue)
				.scaledToFill()
				.minimumScaleFactor(0.1)
				.lineLimit(1)
		}
		.alert(isPresented: $showAlert) {
			Alert(title: Text("Скопированно"), message: nil, dismissButton: nil)
		}
		.onTapGesture {
			UIPasteboard.general.string = descriptionValue
			showAlert = true
		}
	}
}

struct BondDetailRow_Previews: PreviewProvider {
	static var previews: some View {
		BondDetailRow(description: "Имя", descriptionValue: "СуперОблигация 1.0")
	}
}
