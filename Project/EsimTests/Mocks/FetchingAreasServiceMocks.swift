//
//  FetchingAreasServiceMocks.swift
//  EsimTests
//
//  Created by Viacheslav on 15.03.2023.
//

@testable import Esim

final class FetchingAreasServiceMock: IFetchingAreasServicable {
	func getCountriesPopular() -> ESObservable<[Country]> {
		.just(
			[Country(), Country()]
		)
	}
	
	func getImagesForCountries(_: [String]) -> ESObservable<[ESImage]> {
		.just([ESImage(), ESImage()])
	}
}

final class FetchingAreasServiceErrorMock: IFetchingAreasServicable {
	func getCountriesPopular() -> ESObservable<[Country]> {
		.error(
			LocalEsimsViewModel.Error.failedGetServerRespond
		)
	}

	func getImagesForCountries(_: [String]) -> ESObservable<[ESImage]> {
		.error(
			LocalEsimsViewModel.Error.failedGetServerRespond
		)
	}
}
