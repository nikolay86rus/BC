//
//  UIApplication+endEditing.swift
//  BC
//
//  Created by Nikolay on 18.01.2022.
//

import SwiftUI

extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
