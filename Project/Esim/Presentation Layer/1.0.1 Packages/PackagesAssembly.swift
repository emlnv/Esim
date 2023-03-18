//
//  StoreAssembly.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import Foundation.NSUserDefaults

extension ESContainer {
	func packagesViewController(for area: Area) -> PackagesViewController { packagesVC(for: area).callAsFunction() }
	
	private var fetchingPackService: ESFactory<IFetchingPackagesServicable> {
		ESFactory(self) {
			FetchingPackagesService()
	}}
	
	private var userDefaults: ESFactory<UserDefaults> {
		ESFactory(self) {
			UserDefaults.standard
	}}
	
	private func packVM(for area: Area) -> ESFactory<PackagesViewModel> {
		ESFactory(self) {
			PackagesViewModel(
				fetchingPackagesService: self.fetchingPackService.callAsFunction(),
				userDefaults:			 self.userDefaults.callAsFunction(),
				selectedArea: 		 area
			)
	}}
	
	private func packagesVC(for area: Area) -> ESFactory<PackagesViewController> {
		ESFactory(self) {
			PackagesViewController(
				viewModel: self.packVM(for: area).callAsFunction()
			)
	}}
}
