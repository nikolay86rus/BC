//
//  BondListView.swift
//  BC
//
//  Created by Nikolay on 31.12.2021.
//

import SwiftUI

struct BondListView: View {

	@StateObject var viewModel: BondListViewModel

	var body: some View {
		NavigationView {
			List(viewModel.bonds, id: \.self) { bond in
				let bondDetailViewModel = BondDetailViewModel(bondDetailProvider: NetworkService(), bond: bond)
				NavigationLink(destination: BondDetailView(viewModel: bondDetailViewModel)) {
					BondCell(bond: bond)
				}
			}.listStyle(PlainListStyle())
				.navigationBarTitle("Облигации", displayMode: .inline)
				.navigationBarItems(trailing: HStack(spacing: 16) {
					let filtersViewModel = FiltersViewModel(filters: viewModel.filters)
					let filtersSelectView = FiltersSelectView(viewModel: filtersViewModel) {
						viewModel.applyFilters()
					}
					NavigationLink(destination: filtersSelectView) {
						Image(systemName: "slider.horizontal.3")
							.imageScale(.large)
							.foregroundColor(.black)
					}

					Button(action: {
						viewModel.fetchBonds()
					}) {
						Image(systemName: "arrow.clockwise").imageScale(.large).foregroundColor(.black)
					}
				})
		}
	}
}

struct BondCell: View {

	let bond: Bond

	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Text(bond.shortName)
				if let endDate = bond.matDate {
					Text(endDate, style: .date)
				}
			}
			if let realPercentIncomePerYear = bond.realPercentIncomePerYear {
				Spacer()
				Text(String(format: "%.2f%% %@", realPercentIncomePerYear, bond.faceUnit))
			}
		}
	}
}

//struct MainView_Previews: PreviewProvider {
//	static var previews: some View {
//		Group {
//			BondListView(filters: Filters(currencyFilters: [])).environmentObject(Network())
//		}
//	}
//}
