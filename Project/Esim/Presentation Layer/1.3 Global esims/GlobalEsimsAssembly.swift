//
//  StoreAssembly.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import Foundation.NSUserDefaults

extension ESContainer {
	var globalEsimsViewController: GlobalEsimsViewController { globalVC.callAsFunction() }
	
	private var fetchingPackagesService: ESFactory<IFetchingPackagesServicable> {
		ESFactory(self) {
			FetchingPackagesService()
		}}
	
	private var userDefaults: ESFactory<UserDefaults> {
		ESFactory(self) {
			UserDefaults.standard
		}}
	
	private var globalVM: ESFactory<PackagesViewModel> {
		ESFactory(self) {
			PackagesViewModel(
				fetchingPackagesService: self.fetchingPackagesService.callAsFunction(),
				userDefaults:			 self.userDefaults.callAsFunction(),
				selectedArea: 			 nil,
				areaType: 				 .globalRegions
			)
		}}
	
	private var globalVC: ESFactory<GlobalEsimsViewController> {
		ESFactory(self) {
			GlobalEsimsViewController(
				viewModel: self.globalVM.callAsFunction()
			)
		}}
}
