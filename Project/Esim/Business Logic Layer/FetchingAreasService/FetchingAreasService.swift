//
//  FetchingAreasService.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Foundation

protocol IFetchingAreasServicable {
	func getCountriesPopular() -> ESObservable<[Country]>
}

struct FetchingAreasService: IFetchingAreasServicable {
	
	// MARK: - Private properties
	
	private let provider: ESMoyaProvider<EsimTarget>
	private let decoder: JSONDecoder
	
	// MARK: - Initialize
	
	init(
		provider: ESMoyaProvider<EsimTarget> = ESMoyaProvider<EsimTarget>(plugins: [ESNetworkLoggerPlugin()]),
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
}
