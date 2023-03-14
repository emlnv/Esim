//
//  FetchingAreasService.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Foundation

protocol IFetchingPackagesServicable {
	func getPackageBy(id: Int) -> ESObservable<[Package]>
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
	
	func getPackageBy(id: Int) -> ESObservable<[Package]> {
		provider.rx.request(.getPopularCoutries)
			.map([Package].self, using: decoder)
			.asObservable()
	}
	
}
