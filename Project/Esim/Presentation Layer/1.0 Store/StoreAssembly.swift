//
//  StoreAssembly.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import Foundation.NSUserDefaults

extension ESContainer {
	var storeViewController: StoreViewController { storeVC.callAsFunction() }
	
	private var fetchingAreasService: ESFactory<IFetchingAreasServicable> {
		ESFactory(self) {
			FetchingAreasService()
	}}
	
	private var userDefaults: ESFactory<UserDefaults> {
		ESFactory(self) {
			UserDefaults.standard
	}}
	
	private var storeVM: ESFactory<StoreViewModel> {
		ESFactory(self) {
			StoreViewModel(
				fetchingAreasService:	self.fetchingAreasService.callAsFunction(),
				userDefaults:			self.userDefaults.callAsFunction()
			)
	}}
		
	private var storeVC: ESFactory<StoreViewController> {
		ESFactory(self) {
			let vc = StoreViewController(
				localEsimsViewController: ESContainer.shared.localEsimsViewController,
				regionalEsimsViewController: ESContainer.shared.regionalEsimsViewController,
				viewModel: self.storeVM.callAsFunction()
			)
			return vc
	}}
}
