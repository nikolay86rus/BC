//
//  BCApp.swift
//  BC
//
//  Created by Nikolay on 31.12.2021.
//

import SwiftUI

@main
struct BCApp: App {
	var body: some Scene {
		WindowGroup {
			BondListView(viewModel: BondListViewModel(bondsProvider: NetworkService()))
		}
	}
}
