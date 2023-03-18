//
//  RegionPackagesAssembly.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import Foundation.NSUserDefaults

extension ESContainer {
	func regionPackagesViewController(for region: Area) -> PackagesViewController { regionPackagesVC(for: region).callAsFunction() }
	
	private var fetchingPackagesService: ESFactory<IFetchingPackagesServicable> {
		ESFactory(self) {
			FetchingPackagesService()
	}}
	
	private var userDefaults: ESFactory<UserDefaults> {
		ESFactory(self) {
			UserDefaults.standard
	}}
	
	private func regionPackagesVM(for region: Area) -> ESFactory<PackagesViewModel> {
		ESFactory(self) {
			PackagesViewModel(
				fetchingPackagesService: self.fetchingPackagesService.callAsFunction(),
				userDefaults:			 self.userDefaults.callAsFunction(),
				selectedArea: 			 region,
				areaType: 				 .regions
			)
	}}
	
	private func regionPackagesVC(for region: Area) -> ESFactory<PackagesViewController> {
		ESFactory(self) {
			PackagesViewController(
				viewModel: self.regionPackagesVM(for: region).callAsFunction()
			)
	}}
}
