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
		NavigationStack {
			List(viewModel.bonds, id: \.self) { bond in
				let bondDetailViewModel = BondDetailViewModel(bondDetailProvider: NetworkService(), bond: bond)
				NavigationLink {
					BondDetailView(viewModel: bondDetailViewModel)
				} label: {
					BondCell(bond: bond)
				}
			}
			.listStyle(PlainListStyle())
			.navigationTitle(Text("Облигации"))
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItemGroup(placement: .topBarTrailing) {
					let filtersViewModel = FiltersViewModel(filters: viewModel.filters)
					let filtersSelectView = FiltersSelectView(viewModel: filtersViewModel) {
						viewModel.applyFilters()
					}
					NavigationLink {
						filtersSelectView
					} label: {
						Image(systemName: "slider.horizontal.3")
							.imageScale(.large)
							.foregroundStyle(Color.primary)
					}

					Button(action: {
						viewModel.fetchBonds()
					}) {
						Image(systemName: "arrow.clockwise")
							.imageScale(.large)
							.foregroundStyle(Color.primary)
					}
				}
			}
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
