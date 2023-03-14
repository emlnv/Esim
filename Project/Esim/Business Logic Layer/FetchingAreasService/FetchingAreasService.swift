//
//  FetchingAreasService.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Foundation

protocol IFetchingAreasServicable {
	func getCountriesPopular() -> ESObservable<[Country]>
	func getImagesForCountries(_: [String]) -> ESObservable<[ESImage]>
}

struct FetchingAreasService: IFetchingAreasServicable {
	
	// MARK: - Private properties
	
	private let provider: ESMoyaProvider<EsimTarget>
	private let decoder: JSONDecoder
	
	// MARK: - Initialize
	
	init(
		provider: ESMoyaProvider<EsimTarget> = ESMoyaProvider<EsimTarget>(/*plugins: [ESNetworkLoggerPlugin()]*/),
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
	
	func getImagesForCountries(_ urls: [String]) -> ESObservable<[ESImage]> {
		let array = urls.map { getFlag(by: $0)}
		return ESObservable.from(array)
			.merge()
			.toArray()
			.asObservable()
	}
	
	func getFlag(by url: String) -> ESSingle<ESImage> {
		guard let url = URL(string: url) else {
			return .error(StoreViewModel.SVMError.failedGetServerRespond)
		}
		return provider.rx.request(.getFlag(url))
			.mapImage()
	}
}
