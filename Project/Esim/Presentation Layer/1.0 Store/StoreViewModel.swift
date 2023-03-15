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
	}
	
	enum Mutation {
		case toggleError(Error?)
	}
	
	struct State {
		var error: Error?
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
	}
	
	func reduce(state: State, mutation: Mutation) -> State {
		var newState = state
		newState.error = nil
		switch mutation {
			case .toggleError(let error):
				newState.error = error
		}
		return newState
	}	
}
