//
//  StoreViewModel.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import Foundation

final class LocalEsimsViewModel: ESReactor {
	enum Error: LocalizedError, Equatable {
		case failedGetServerRespond
		case failedCreatingURL
	}
	
	enum Action {
		case getAreasPopular
		case setSelectArea(Area)
	}
	
	enum Mutation {
		case toggleError(Swift.Error?)
		case mutateAreas([Area])
		case mutateAreaWithImages([Area])
		case mutateSelectedArea(Area)
		case mutateIsLoading(Bool)
	}
	
	struct State {
		var error: Swift.Error?
		var countriesPopular: [Area]?
		var countriesWithImage: [Area]?
		var selectedArea: Area?
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
			case .getAreasPopular:
				return getAreasPopular
			case .setSelectArea(let area):
				return .just(.mutateSelectedArea(area))
		}
	}
	
	func reduce(state: State, mutation: Mutation) -> State {
		var newState = state
		newState.error = nil
		switch mutation {
			case .toggleError(let error):
				newState.error = error
			case .mutateAreas(let countries):
				newState.countriesPopular = countries
			case .mutateAreaWithImages(let countries):
				newState.countriesWithImage = countries
			case .mutateSelectedArea(let area):
				newState.selectedArea = area
			case .mutateIsLoading(let isLoading):
				newState.isLoading = isLoading
		}
		return newState
	}
	
	private var getAreasPopular: ESObservable<Mutation> {
		.concat(
			.just(.mutateIsLoading(true)),
			fetchingAreasService.getAreasPopular()
				.flatMap { model -> ESObservable<Mutation> in
						.concat(
							.just(.mutateAreas(model.sorted { $0.title < $1.title } )),
							self.getImagesFor(countries: model)
						)
				}
				.catch { error in
						.just(.toggleError(error))
				},
			.just(.mutateIsLoading(false))
		)
			
	}

	private func getImagesFor(countries: [Area]) -> ESObservable<Mutation> {
		.concat(
			.just(.mutateIsLoading(true)),
			fetchingAreasService.getImages(for: countries)
				.flatMap { model -> ESObservable<Mutation> in
						.just(.mutateAreaWithImages(model))
				}
				.catch { error in
						.just(.toggleError(error))
				},
			.just(.mutateIsLoading(true))
		)
	}
}
