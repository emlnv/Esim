//
//  StoreViewModel.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import Foundation

final class PackagesViewModel: ESReactor {
	enum PVMError: LocalizedError {
		case failedGetServerRespond
		case failedCreatingURL
	}
	
	enum Action {
		case getPackagesBy(id: Int)
	}
	
	enum Mutation {
		case toggleError(Error?)
		case mutatePackages([Package])
	}
	
	struct State {
		var error: Error?
		var packages: [Package]?
		var selectedPackage: Package?
	}
	
	// MARK: - Dependencies
	
	private let fetchingPackagesService: IFetchingPackagesServicable
	
	// MARK: - Internal properties
	
	let initialState = State()
	
	// MARK: - Private properties
	
	private let userDefaults: UserDefaults
	
	// MARK: - Lifecycle
	
	init(
		fetchingPackagesService: IFetchingPackagesServicable,
		userDefaults: UserDefaults
	) {
		self.fetchingPackagesService = fetchingPackagesService
		self.userDefaults = userDefaults
	}
	
	func mutate(action: Action) -> ESObservable<Mutation> {
		switch action {
			case .getPackagesBy(let id):
				return getPackageBy(id)
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
		}
		return newState
	}
	
	private func getPackageBy(_ id: Int) -> ESObservable<Mutation> {
		return fetchingPackagesService.getPackageBy(id: id)
			.flatMap { model -> ESObservable<Mutation> in
				return .just(.mutatePackages(model))
			}
			.catch { error in
				.just(.toggleError(error))
			}
	}
}
