//
//  StoreViewModel.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import Foundation

final class AreasViewModel: ESReactor {
	enum AreaType {
		case countries, regions
	}
	enum Error: LocalizedError, Equatable {
		case failedGetServerRespond
		case failedCreatingURL
	}
	
	enum Action {
		case getAreas
		case setSelectArea(Area?)
	}
	
	enum Mutation {
		case toggleError(Swift.Error?)
		case mutateAreas([Area])
		case mutateAreaWithImages([Area])
		case mutateSelectedArea(Area?)
		case mutateIsLoading(Bool)
	}
	
	struct State {
		var error: Swift.Error?
		var areasPopular: [Area]?
		var areasWithImage: [Area]?
		var selectedArea: Area?
		var isLoading: Bool = false
	}
	
	// MARK: - Dependencies
	
	private let fetchingAreasService: IFetchingAreasServicable
	
	// MARK: - Internal properties
	
	let initialState = State()
	
	// MARK: - Private properties
	
	private let userDefaults: UserDefaults
	private let areaType: AreaType
	
	// MARK: - Lifecycle
	
	init(
		fetchingAreasService: IFetchingAreasServicable,
		userDefaults: UserDefaults,
		areaType: AreaType
	) {
		self.fetchingAreasService = fetchingAreasService
		self.userDefaults = userDefaults
		self.areaType = areaType
	}
	
	func mutate(action: Action) -> ESObservable<Mutation> {
		switch action {
			case .getAreas:
				return .just(.mutateSelectedArea(nil)).concat(getRegions)
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
			case .mutateAreas(let areas):
				newState.areasPopular = areas
			case .mutateAreaWithImages(let areas):
				newState.areasWithImage = areas
			case .mutateSelectedArea(let area):
				newState.selectedArea = area
			case .mutateIsLoading(let isLoading):
				newState.isLoading = isLoading
		}
		return newState
	}
	
	private var getRegions: ESObservable<Mutation> {
		.concat(
			.just(.mutateIsLoading(true)),
			(areaType == .regions ? fetchingAreasService.getRegions() : fetchingAreasService.getAreasPopular())
				.flatMap { model -> ESObservable<Mutation> in
						.concat(
							.just(.mutateAreas(model.sorted { $0.title < $1.title } )),
							self.getImagesFor(areas: model)
						)
				}
				.catch { error in
						.just(.toggleError(error))
				},
			.just(.mutateIsLoading(false))
		)
			
	}

	private func getImagesFor(areas: [Area]) -> ESObservable<Mutation> {
		.concat(
			.just(.mutateIsLoading(true)),
			fetchingAreasService.getImages(for: areas)
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
