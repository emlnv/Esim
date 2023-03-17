//
//  FetchingAreasService.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Foundation

protocol IFetchingPackagesServicable {
	func getPackagesByCountry(id: Int) -> ESObservable<Country>
	func getImages(for packages: [Package]) -> ESObservable<[Package]>
	func getGlobalPackages() -> ESObservable<Country>
}

struct FetchingPackagesService: IFetchingPackagesServicable {
	
	// MARK: - Private properties
	
	private let provider: ESMoyaProvider<EsimTarget> // todo add target
	private let decoder: JSONDecoder
	
	private static let networkActivityPlugin = ESNetworkActivityPlugin(networkActivityClosure: {change, target in
		switch change {
			case .began: ()
			case .ended: ()
		}
	})
	private static let defaultProvider = ESMoyaProvider<EsimTarget>(plugins: [networkActivityPlugin])
	
	// MARK: - Initialize
	
	init(
		provider: ESMoyaProvider<EsimTarget> = defaultProvider,
		decoder: JSONDecoder = JSONDecoder()) {
			self.provider = provider
			self.decoder = decoder
		}
	
	// MARK: - Protocol
	
	func getPackagesByCountry(id: Int) -> ESObservable<Country> {
		provider.rx.request(.getPackagesForCountry(id))
			.map(Country.self, using: decoder)
			.asObservable()
	}
	
	func getImages(for packages: [Package]) -> ESObservable<[Package]> {
		let array: Array<ESObservable<Package>> = packages.map { package in
			getImage(by: package.operator?.image.url ?? String())
				.compactMap { image in
					var package = package
					package.operator?.imageData = image.pngData()
					return package
				}
				.asObservable()
		}
		return ESObservable.from(array)
			.merge()
			.toArray()
			.asObservable()
	}
	
	private func getImage(by url: String) -> ESSingle<ESImage> {
		guard let url = URL(string: url) else {
			return .error(StoreViewModel.Error.failedGetServerRespond)
		}
		return provider.rx.request(.getImage(url))
			.mapImage()
	}
	
	func getGlobalPackages() -> ESObservable<Country> {
		provider.rx.request(.getGlobalPackages)
			.map(Country.self, using: decoder)
			.asObservable()
	}
}
