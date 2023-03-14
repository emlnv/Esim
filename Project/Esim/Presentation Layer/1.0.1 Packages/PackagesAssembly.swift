//
//  StoreAssembly.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import Foundation.NSUserDefaults

extension ESContainer {
	var packagesViewController: PackagesViewController { packagesVC.callAsFunction() }
	
	private var fetchingPackService: ESFactory<IFetchingPackagesServicable> {
		ESFactory(self) {
			FetchingPackagesService()
		}}
	
	private var userDefaults: ESFactory<UserDefaults> {
		ESFactory(self) {
			UserDefaults.standard
		}}
	
	private var packVM: ESFactory<PackagesViewModel> {
		ESFactory(self) {
			PackagesViewModel(
				fetchingPackagesService: self.fetchingPackService.callAsFunction(),
				userDefaults:			 self.userDefaults.callAsFunction()
			)
		}}
	
	private var packagesVC: ESFactory<PackagesViewController> {
		ESFactory(self) {
			PackagesViewController(
				viewModel: self.packVM.callAsFunction()
			)
	}}
}
