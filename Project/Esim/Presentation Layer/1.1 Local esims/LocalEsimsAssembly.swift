//
//  StoreAssembly.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import Foundation.NSUserDefaults

extension ESContainer {
	var localEsimsViewController: LocalEsimsViewController { localVC.callAsFunction() }
	
	private var fetchingAreasService: ESFactory<IFetchingAreasServicable> {
		ESFactory(self) {
			FetchingAreasService()
	}}
	
	private var userDefaults: ESFactory<UserDefaults> {
		ESFactory(self) {
			UserDefaults.standard
	}}
	
	private var localVM: ESFactory<AreasViewModel> {
		ESFactory(self) {
			AreasViewModel(
				fetchingAreasService:	self.fetchingAreasService.callAsFunction(),
				userDefaults:			self.userDefaults.callAsFunction(),
				areaType: 				.countries
			)
	}}
		
	private var localVC: ESFactory<LocalEsimsViewController> {
		ESFactory(self) {
			LocalEsimsViewController(
				viewModel: self.localVM.callAsFunction()
			)
	}}
}
