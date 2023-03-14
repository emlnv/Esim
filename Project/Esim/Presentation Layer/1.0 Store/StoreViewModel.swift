//
//  StoreViewModel.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Foundation

final class StoreViewModel: ESReactor {
	enum SVMError: LocalizedError {
		case failedGetServerRespond
		case failedCreatingURL
	}
	
	enum Action {
		case getCountriesPopular
		case setSelectCountry(CountryWithImage)
	}
	
	enum Mutation {
		case toggleError(Error?)
		case mutateCountries([Country])
		case mutateImagesForCountries([ESImage])
		case mutateCountryWithImages([CountryWithImage])
		case mutateSelectedCountry(CountryWithImage)
	}
	
	struct State {
		var error: Error?
		var countriesPopular: [Country]?
		var imagesForCountries: [ESImage]?
		var countriesWithImage: [CountryWithImage]?
		var selectedCountry: CountryWithImage?
	}
	
	// MARK: - Dependencies
	
	private let fetchingAreasService: IFetchingAreasServicable
	
	// MARK: - Internal properties
	
	let initialState = State()
	
	// MARK: - Private properties
	
	private let userDefaults: UserDefaults
	
	// MARK: - Lifecycle
	
	init(
		fetchingAreasService: IFetchingAreasServicable,
		userDefaults: UserDefaults
	) {
		self.fetchingAreasService = fetchingAreasService
		self.userDefaults = userDefaults
	}
	
	func mutate(action: Action) -> ESObservable<Mutation> {
		switch action {
			case .getCountriesPopular:
				return getCountriesPopular
			case .setSelectCountry(let country):
				return .just(.mutateSelectedCountry(country))
		}
	}
	
	func reduce(state: State, mutation: Mutation) -> State {
		var newState = state
		newState.error = nil
		switch mutation {
			case .toggleError(let error):
				newState.error = error
			case .mutateCountries(let countries):
				newState.countriesPopular = countries
			case .mutateImagesForCountries(let images):
				newState.imagesForCountries = images
			case .mutateCountryWithImages(let countries):
				newState.countriesWithImage = countries
			case .mutateSelectedCountry(let country):
				newState.selectedCountry = country
		}
		return newState
	}
	
	private var getCountriesPopular: ESObservable<Mutation> {
		fetchingAreasService.getCountriesPopular()
			.flatMap { model -> ESObservable<Mutation> in
				.concat(
					.just(.mutateCountries(model.sorted { $0.title < $1.title } )),
					self.getImagesForCountries(urls: model.compactMap { $0.image.url })
					)
			}
			.catch { error in
					.just(.toggleError(error))
			}
	}

	private func getImagesForCountries(urls: [String]) -> ESObservable<Mutation> {
		return fetchingAreasService.getImagesForCountries(urls)
			.flatMap { model -> ESObservable<Mutation> in
				let countries = self.currentState.countriesPopular?.enumerated().map { CountryWithImage(country: $1, image: model[$0]) } ?? []
				return .concat(
					.just(.mutateImagesForCountries(model)),
					.just(.mutateCountryWithImages(countries))
				)
			}
			.catch { error in
					.just(.toggleError(error))
			}
	}
}
