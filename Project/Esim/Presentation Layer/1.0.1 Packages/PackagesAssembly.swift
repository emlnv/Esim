//
//  StoreAssembly.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import Foundation.NSUserDefaults

extension ESContainer {
	func packagesViewController(for country: Country) -> PackagesViewController { packagesVC(for: country).callAsFunction() }
	
	private var fetchingPackService: ESFactory<IFetchingPackagesServicable> {
		ESFactory(self) {
			FetchingPackagesService()
	}}
	
	private var userDefaults: ESFactory<UserDefaults> {
		ESFactory(self) {
			UserDefaults.standard
	}}
	
	private func packVM(for country: Country) -> ESFactory<PackagesViewModel> {
		ESFactory(self) {
			PackagesViewModel(
				fetchingPackagesService: self.fetchingPackService.callAsFunction(),
				userDefaults:			 self.userDefaults.callAsFunction(),
				selectedCountry: 		 country
			)
	}}
	
	private func packagesVC(for country: Country) -> ESFactory<PackagesViewController> {
		ESFactory(self) {
			PackagesViewController(
				viewModel: self.packVM(for: country).callAsFunction()
			)
	}}
}
