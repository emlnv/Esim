//
//  RegionPackagesAssembly.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import Foundation.NSUserDefaults

extension ESContainer {
	func regionPackagesViewController(for region: Country) -> RegionPackagesViewController { regionPackagesVC(for: region).callAsFunction() }
	
	private var fetchingPackagesService: ESFactory<IFetchingPackagesServicable> {
		ESFactory(self) {
			FetchingPackagesService()
		}}
	
	private var userDefaults: ESFactory<UserDefaults> {
		ESFactory(self) {
			UserDefaults.standard
		}}
	
	private func regionPackagesVM(for region: Country) -> ESFactory<RegionPackagesViewModel> {
		ESFactory(self) {
			RegionPackagesViewModel(
				fetchingPackagesService: self.fetchingPackagesService.callAsFunction(),
				userDefaults:			 self.userDefaults.callAsFunction(),
				selectedRegion:	region
			)
		}}
	
	private func regionPackagesVC(for region: Country) -> ESFactory<RegionPackagesViewController> {
		ESFactory(self) {
			RegionPackagesViewController(
				viewModel: self.regionPackagesVM(for: region).callAsFunction()
			)
		}}
}
