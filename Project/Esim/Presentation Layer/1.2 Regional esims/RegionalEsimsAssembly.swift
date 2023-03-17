//
//  StoreAssembly.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import Foundation.NSUserDefaults

extension ESContainer {
	var regionalEsimsViewController: RegionalEsimsViewController { regionalVC.callAsFunction() }
	
	private var fetchingAreasService: ESFactory<IFetchingAreasServicable> {
		ESFactory(self) {
			FetchingAreasService()
		}}
	
	private var userDefaults: ESFactory<UserDefaults> {
		ESFactory(self) {
			UserDefaults.standard
		}}
	
	private var regionalVM: ESFactory<RegionalEsimsViewModel> {
		ESFactory(self) {
			RegionalEsimsViewModel(
				fetchingAreasService:	self.fetchingAreasService.callAsFunction(),
				userDefaults:			self.userDefaults.callAsFunction()
			)
		}}
	
	private var regionalVC: ESFactory<RegionalEsimsViewController> {
		ESFactory(self) {
			RegionalEsimsViewController(
				viewModel: self.regionalVM.callAsFunction()
			)
		}}
}
