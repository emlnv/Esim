//
//  StoreAssembly.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import Foundation.NSUserDefaults

extension ESContainer {
	var localEsimsViewController: AreasViewController { localVC.callAsFunction() }
	
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
		
	private var localVC: ESFactory<AreasViewController> {
		ESFactory(self) {
			AreasViewController(
				viewModel: self.localVM.callAsFunction()
			)
	}}
}
