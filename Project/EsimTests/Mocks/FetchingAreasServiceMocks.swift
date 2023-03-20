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
	
	func getImages(for: [Area]) -> ESObservable<[Area]> {
		.just([Area(), Area()])
	}
	
	func getRegions() -> ESObservable<[Area]> {
		.just([Area(), Area()])
	}
}

final class FetchingAreasServiceErrorMock: IFetchingAreasServicable {
	func getAreasPopular() -> ESObservable<[Area]> {
		.error(
			AreasViewModel.Error.failedGetServerRespond
		)
	}

	func getImages(for: [Area]) -> ESObservable<[Area]> {
		.error(
			AreasViewModel.Error.failedGetServerRespond
		)
	}

	func getRegions() -> ESObservable<[Area]> {
		.error(
			AreasViewModel.Error.failedGetServerRespond
		)
	}
}
