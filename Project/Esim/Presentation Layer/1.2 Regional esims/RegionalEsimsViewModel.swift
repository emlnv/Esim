//
//  StoreViewModel.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import Foundation

final class RegionalEsimsViewModel: ESReactor {
	
	enum Error: LocalizedError, Equatable {
		case failedGetServerRespond
		case failedCreatingURL
	}
	
	enum Action {
		case getRegions
		case setSelectCountry(CountryWithImage)
	}
	
	enum Mutation {
		case toggleError(Error?)
		case mutateCountries([Country])
		case mutateCountryWithImages([CountryWithImage])
		case mutateSelectedCountry(CountryWithImage)
		case mutateIsLoading(Bool)
	}
	
	struct State {
		var error: Error?
		var countriesPopular: [Country]?
		var countriesWithImage: [CountryWithImage]?
		var selectedCountry: CountryWithImage?
		var isLoading: Bool = false
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
			case .getRegions:
				return getRegions
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
			case .mutateCountryWithImages(let countries):
				newState.countriesWithImage = countries
			case .mutateSelectedCountry(let country):
				newState.selectedCountry = country
			case .mutateIsLoading(let isLoading):
				newState.isLoading = isLoading
		}
		return newState
	}
	
	private var getRegions: ESObservable<Mutation> {
		.concat(
			.just(.mutateIsLoading(true)),
			fetchingAreasService.getRegions()
				.flatMap { model -> ESObservable<Mutation> in
						.concat(
							.just(.mutateCountries(model.sorted { $0.title < $1.title } )),
							self.getImagesFor(countries: model)
						)
				}
				.catch { error in
						.just(.toggleError(error as? Error))
				},
			.just(.mutateIsLoading(false))
		)
			
	}

	private func getImagesFor(countries: [Country]) -> ESObservable<Mutation> {
		.concat(
			.just(.mutateIsLoading(true)),
			fetchingAreasService.getImages(for: countries)
				.flatMap { model -> ESObservable<Mutation> in
						.just(.mutateCountryWithImages(model))
				}
				.catch { error in
						.just(.toggleError(error as? Error))
				},
			.just(.mutateIsLoading(true))
		)
	}
}
