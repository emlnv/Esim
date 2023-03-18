//
//  StoreAssembly.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import Foundation.NSUserDefaults

extension ESContainer {
	var regionalEsimsViewController: AreasViewController { regionalVC.callAsFunction() }
	
	private var fetchingAreasService: ESFactory<IFetchingAreasServicable> {
		ESFactory(self) {
			FetchingAreasService()
		}}
	
	private var userDefaults: ESFactory<UserDefaults> {
		ESFactory(self) {
			UserDefaults.standard
		}}
	
	private var regionalVM: ESFactory<AreasViewModel> {
		ESFactory(self) {
			AreasViewModel(
				fetchingAreasService:	self.fetchingAreasService.callAsFunction(),
				userDefaults:			self.userDefaults.callAsFunction(),
				areaType: 				.regions
			)
		}}
	
	private var regionalVC: ESFactory<AreasViewController> {
		ESFactory(self) {
			AreasViewController(
				viewModel: self.regionalVM.callAsFunction()
			)
		}}
}
