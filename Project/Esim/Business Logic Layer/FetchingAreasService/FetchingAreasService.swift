//
//  FetchingAreasService.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Foundation

protocol IFetchingAreasServicable {
	func getCountriesPopular() -> ESObservable<[Country]>
	func getImages(for: [Country]) -> ESObservable<[Country]>
	func getRegions() -> ESObservable<[Country]>
}

struct FetchingAreasService: IFetchingAreasServicable {
	
	// MARK: - Private properties
	
	private let provider: ESMoyaProvider<EsimTarget>
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
	
	// MARK: - IAppUpdateServiceProtocol
	
	func getCountriesPopular() -> ESObservable<[Country]> {
		provider.rx.request(.getPopularCoutries)
			.map([Country].self, using: decoder)
			.asObservable()
	}
	
	func getImages(for countries: [Country]) -> ESObservable<[Country]> {
		let array: Array<ESObservable<Country>> = countries.map { country in
			getFlag(by: country.image.url)
				.compactMap { image in
					var country = country
					country.imageData = image.pngData()
					return country
				}
			.asObservable()
		}
		return ESObservable.from(array)
			.merge()
			.toArray()
			.asObservable()
	}
	
	private func getFlag(by url: String) -> ESSingle<ESImage> {
		guard let url = URL(string: url) else {
			return .error(StoreViewModel.Error.failedGetServerRespond)
		}
		return provider.rx.request(.getImage(url))
			.mapImage()
	}
	
	func getRegions() -> ESObservable<[Country]> {
		provider.rx.request(.getRegions)
			.map([Country].self, using: decoder)
			.asObservable()
	}
}
