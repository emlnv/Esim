//
//  StoreViewModel.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Foundation

final class StoreViewModel: ESReactor {
	enum Error: LocalizedError {
		case failedGetServerRespond
	}
	
	enum Action {
		case getCountriesPopular
		case selectCountry
	}
	
	enum Mutation {
		case toggleError(Error?)
		case setCountries([Country])
	}
	
	struct State {
		var error: Error?
		var countriesPopular: [Country]?
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
				return getCountriesPopular()
			case .selectCountry:
				return ESObservable<Mutation>.empty()
		}
	}
	
	func reduce(state: State, mutation: Mutation) -> State {
		var newState = state
		newState.error = nil
		switch mutation {
			case .toggleError(let error):
				newState.error = error
			case .setCountries(let countries):
				newState.countriesPopular = countries
		}
		return newState
	}
	
	private func getCountriesPopular() -> ESObservable<Mutation> {
		fetchingAreasService.getCountriesPopular()
			.flatMap { model -> ESObservable<Mutation> in
					.just(.setCountries(model.sorted { $0.title < $1.title } ))
			}
			.catch { error in
					.just(.toggleError(error as? StoreViewModel.Error))
			}
	}
}
