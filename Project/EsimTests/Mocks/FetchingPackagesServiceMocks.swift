//
//  FetchingAreasServiceMocks.swift
//  EsimTests
//
//  Created by Viacheslav on 15.03.2023.
//

@testable import Esim

final class FetchingPackagesServiceMocks: IFetchingPackagesServicable {
	func getGlobalPackages() -> ESObservable<Area> {
		.just(Area())
	}
	
	func getImages(for: [Package]) -> ESObservable<[Package]> {
		.just([Package(), Package()])
	}
	
	func getPackagesByRegion(id: Int) -> ESObservable<Area> {
		.just(Area())
	}

	func getPackagesByArea(id: Int) -> ESObservable<Area> {
		.just(Area())
	}
}

final class FetchingPackagesServiceErrorMocks: IFetchingPackagesServicable {
	func getGlobalPackages() -> ESObservable<Area> {
		.error(PackagesViewModel.Error.failedGetServerRespond)
	}
	
	func getImages(for: [Package]) -> ESObservable<[Package]> {
		.error(PackagesViewModel.Error.failedGetServerRespond)
	}
	
	func getPackagesByRegion(id: Int) -> ESObservable<Area> {
		.error(PackagesViewModel.Error.failedGetServerRespond)
	}
	
	func getPackagesByArea(id: Int) -> ESObservable<Area> {
		.error(PackagesViewModel.Error.failedGetServerRespond)
	}
}
