//
//  EsimTests.swift
//  EsimTests
//
//  Created by Viacheslav on 15.03.2023.
//

@testable import Esim
import XCTest
import RxTest
import RxSwift

final class LocalEsimsViewModelTestCase: XCTestCase {
	
	var sut: LocalEsimsViewModel!
	var disposeBag: DisposeBag!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = .init(
			fetchingAreasService: FetchingAreasServiceErrorMock(),
			userDefaults: UserDefaults.standard
		)
		disposeBag = .init()
	}
	
	override func tearDownWithError() throws {
		disposeBag = nil
		sut = nil
		try super.tearDownWithError()
	}
	
	func testSuccessfulGetDataByViewModel() throws {
		sut = .init(
			fetchingAreasService: FetchingAreasServiceMock(),
			userDefaults: UserDefaults.standard
		)
		
		let successStub = [
			Area(),
			Area()
		]
		
		let scheduler = TestScheduler(initialClock: 0)
		scheduler.createHotObservable([.next(100, .getAreasPopular)])
			.bind(to: sut.action)
			.disposed(by: disposeBag)
		
		let response = scheduler.start(
			created: 0,
			subscribed: 0,
			disposed: TestScheduler.Defaults.disposed
		) { [unowned self] in
			self.sut.state
		}
		
		XCTAssertEqual(
			sut.currentState.areasPopular,
			successStub
		)
		
		XCTAssertNil(sut.currentState.error)
		
		let states = response.events.compactMap(\.value.element)
		XCTAssertEqual(
			states.map(\.areasPopular),
			[
				nil,				// initial state event
				successStub			// recieved data event
			]
		)
		
	}
	
	func testFailureGetErrorByViewModel() throws {
		sut = .init(
			fetchingAreasService: FetchingAreasServiceErrorMock(),
			userDefaults: UserDefaults.standard
		)
		
		let scheduler = TestScheduler(initialClock: 0)
		scheduler.createHotObservable([.next(100, .getAreasPopular)])
			.bind(to: sut.action)
			.disposed(by: disposeBag)
		let response = scheduler.start(
			created: 0,
			subscribed: 0,
			disposed: TestScheduler.Defaults.disposed
		) { [unowned self] in
			self.sut.state
		}
		
		XCTAssertNil(sut.currentState.areasPopular)
		XCTAssertEqual(sut.currentState.error, LocalEsimsViewModel.Error.failedGetServerRespond)
		let states = response.events.compactMap(\.value.element)
		XCTAssertEqual(
			states.map(\.error),
			[
				nil,												// initial state
				LocalEsimsViewModel.Error.failedGetServerRespond	// recieved data event
			]
		)
		
	}
	
}
