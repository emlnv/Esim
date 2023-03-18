//
//  FetchingAreasServiceMocks.swift
//  EsimTests
//
//  Created by Viacheslav on 15.03.2023.
//

@testable import Esim

final class FetchingAreasServiceMock: IFetchingAreasServicable {
	func getAreasPopular() -> ESObservable<[Area]> {
		.just(
			[Area(), Area()]
		)
	}
	
	func getImagesForAreas(_: [String]) -> ESObservable<[ESImage]> {
		.just([ESImage(), ESImage()])
	}
}

final class FetchingAreasServiceErrorMock: IFetchingAreasServicable {
	func getAreasPopular() -> ESObservable<[Area]> {
		.error(
			LocalEsimsViewModel.Error.failedGetServerRespond
		)
	}

	func getImagesForAreas(_: [String]) -> ESObservable<[ESImage]> {
		.error(
			LocalEsimsViewModel.Error.failedGetServerRespond
		)
	}
}
