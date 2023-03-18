//
//  RegionPackagesViewModel.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import Foundation

final class RegionPackagesViewModel: ESReactor {
	
	enum Error: LocalizedError {
		case failedGetServerRespond
		case failedCreatingURL
	}
	
	enum Action {
		case getPackagesBy(id: Int)
	}
	
	enum Mutation {
		case toggleError(Swift.Error?)
		case mutatePackages([Package])
		case mutateIsLoading(Bool)
	}
	
	struct State {
		var error: Swift.Error?
		var packages: [Package]?
		var selectedArea: Area
		var isLoading: Bool = false
	}
	
	// MARK: - Dependencies
	
	private let fetchingPackagesService: IFetchingPackagesServicable
	private let userDefaults: UserDefaults
	private let selectedArea: Area
	
	// MARK: - Internal properties
	
	let initialState: State
	
	// MARK: - Private properties
	
	
	// MARK: - Lifecycle
	
	init(
		fetchingPackagesService: IFetchingPackagesServicable,
		userDefaults: UserDefaults,
		selectedRegion: Area
	) {
		self.fetchingPackagesService = fetchingPackagesService
		self.userDefaults = userDefaults
		self.selectedArea = selectedRegion
		self.initialState =  State(selectedArea: selectedArea)
	}
	
	func mutate(action: Action) -> ESObservable<Mutation> {
		switch action {
			case .getPackagesBy(let id):
				return getPackagesByArea(id)
		}
	}
	
	func reduce(state: State, mutation: Mutation) -> State {
		var newState = state
		newState.error = nil
		switch mutation {
			case .toggleError(let error):
				newState.error = error
			case .mutatePackages(let packages):
				newState.packages = packages
			case .mutateIsLoading(let isLoading):
				newState.isLoading = isLoading
		}
		return newState
	}
	
	private func getPackagesByArea(_ id: Int) -> ESObservable<Mutation> {
		.concat(
			.just(.mutateIsLoading(true)),
			
			fetchingPackagesService.getPackagesByRegion(id: id)
				.flatMap { self.getImagesFor(packages: $0.packages ?? []) }
				.catch { .just(.toggleError($0)) },
			
				.just(.mutateIsLoading(false))
		)
	}
	
	private func getImagesFor(packages: [Package]) -> ESObservable<Mutation> {
		.concat(
			.just(.mutateIsLoading(true)),
			
			fetchingPackagesService.getImages(for: packages)
				.flatMap { model -> ESObservable<Mutation> in
					.just(.mutatePackages(model)) }
				.catch { error in
					.just(.toggleError(error)) },
			
				.just(.mutateIsLoading(true))
		)
	}
}