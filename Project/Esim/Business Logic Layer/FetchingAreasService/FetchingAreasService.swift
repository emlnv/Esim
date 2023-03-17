//
//  FetchingAreasService.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Foundation

protocol IFetchingAreasServicable {
	func getCountriesPopular() -> ESObservable<[Country]>
	func getImages(for: [Country]) -> ESObservable<[CountryWithImage]>
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
	
	func getImages(for countries: [Country]) -> ESObservable<[CountryWithImage]> {
		let array: Array<ESObservable<CountryWithImage>> = countries.map { country in
			getFlag(by: country.image.url)
			.compactMap { CountryWithImage(country: country, image: $0) }
			.asObservable()
		}
		return ESObservable.from(array)
			.merge()
			.toArray()
			.asObservable()
	}
	
	private func getFlag(by url: String) -> ESSingle<ESImage> {
		guard let url = URL(string: url) else {
			return .error(StoreViewModel.SVMError.failedGetServerRespond)
		}
		return provider.rx.request(.getImage(url))
			.mapImage()
	}
}
