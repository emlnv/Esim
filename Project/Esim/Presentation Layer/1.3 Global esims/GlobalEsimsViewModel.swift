//
//  StoreViewModel.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import Foundation

final class GlobalEsimsViewModel: ESReactor {
	
	enum Error: LocalizedError {
		case failedGetServerRespond
		case failedCreatingURL
	}
	
	enum Action {
		case getGlobalPackages
	}
	
	enum Mutation {
		case toggleError(Swift.Error?)
		case mutatePackages([Package])
		case mutateIsLoading(Bool)
	}
	
	struct State {
		var error: Swift.Error?
		var packages: [Package]?
		var isLoading: Bool = false
	}
	
	// MARK: - Dependencies
	
	private let fetchingPackagesService: IFetchingPackagesServicable
	private let userDefaults: UserDefaults
	
	// MARK: - Internal properties
	
	let initialState: State
	
	// MARK: - Private properties
	
	
	// MARK: - Lifecycle
	
	init(
		fetchingPackagesService: IFetchingPackagesServicable,
		userDefaults: UserDefaults
	) {
		self.fetchingPackagesService = fetchingPackagesService
		self.userDefaults = userDefaults
		self.initialState =  State()
	}
	
	func mutate(action: Action) -> ESObservable<Mutation> {
		switch action {
			case .getGlobalPackages:
				return getPackages()
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
	
	private func getPackages() -> ESObservable<Mutation> {
		.concat(
			.just(.mutateIsLoading(true)),
			
			fetchingPackagesService.getGlobalPackages()
				.flatMap { self.getImagesFor(packages: $0.packages ?? []) }
				.catch {
					.just(.toggleError($0)) },
			
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