//
//  FetchingAreasService.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Foundation

protocol IFetchingAreasServicable {
	func getAreasPopular() -> ESObservable<[Area]>
	func getImages(for: [Area]) -> ESObservable<[Area]>
	func getRegions() -> ESObservable<[Area]>
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
	
	func getAreasPopular() -> ESObservable<[Area]> {
		provider.rx.request(.getPopularCoutries)
			.map([Area].self, using: decoder)
			.asObservable()
	}
	
	func getImages(for areas: [Area]) -> ESObservable<[Area]> {
		let array: Array<ESObservable<Area>> = areas.map { area in
			getFlag(by: area.image.url)
				.compactMap { image in
					var area = area
					area.imageData = image.pngData()
					return area
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
	
	func getRegions() -> ESObservable<[Area]> {
		provider.rx.request(.getRegions)
			.map([Area].self, using: decoder)
			.asObservable()
	}
}
