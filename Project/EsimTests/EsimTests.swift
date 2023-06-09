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

final class AreasViewModelTestCase: XCTestCase {
	
	var sut: AreasViewModel!
	var disposeBag: DisposeBag!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = .init(
			fetchingAreasService: FetchingAreasServiceErrorMock(),
			userDefaults: UserDefaults.standard,
			areaType: .countries
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
			userDefaults: UserDefaults.standard,
			areaType: .countries
		)
		
		let successStub = [
			Area(),
			Area()
		]
		
		let scheduler = TestScheduler(initialClock: 0)
		scheduler.createHotObservable([.next(0, .getAreas)])
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
				successStub,
			]
		)
		
	}
	
	func testFailureGetErrorByViewModel() throws {
		sut = .init(
			fetchingAreasService: FetchingAreasServiceErrorMock(),
			userDefaults: UserDefaults.standard,
			areaType: .countries
		)
		
		let scheduler = TestScheduler(initialClock: 0)
		scheduler.createHotObservable([.next(1, .getAreas)])
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
		
		let states = response.events.compactMap(\.value.element)
		XCTAssertEqual(
			states.compactMap{ $0.error?.localizedDescription },
			[
				AreasViewModel.Error.failedGetServerRespond.localizedDescription,
			]
		)
		
	}
}
