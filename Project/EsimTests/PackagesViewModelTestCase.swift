//
//  EsimTests.swift
//  EsimTests
//
//  Created by Viacheslav on 20.03.2023.
//

@testable import Esim
import XCTest
import RxTest
import RxSwift

final class PackagesViewModelTestCase: XCTestCase {
	
	var sut: PackagesViewModel!
	var disposeBag: DisposeBag!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = .init(
			fetchingPackagesService: FetchingPackagesServiceMocks(),
			userDefaults: UserDefaults.standard,
			selectedArea: nil,
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
			fetchingPackagesService: FetchingPackagesServiceMocks(),
			userDefaults: UserDefaults.standard,
			selectedArea: nil,
			areaType: .countries
		)
		
		let successStub = [
			Package(),
			Package()
		]
		
		let scheduler = TestScheduler(initialClock: 0)
		scheduler.createHotObservable([.next(0, .getPackagesBy(id: 0))])
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
			sut.currentState.packages,
			successStub
		)
		
		XCTAssertNil(sut.currentState.error)
		
		let states = response.events.compactMap(\.value.element)
		XCTAssertEqual(
			states.map(\.packages),
			[
				successStub,
			]
		)
		
	}
	
	func testFailureGetErrorByViewModel() throws {
		sut = .init(
			fetchingPackagesService: FetchingPackagesServiceErrorMocks(),
			userDefaults: UserDefaults.standard,
			selectedArea: nil,
			areaType: .countries
		)

		let scheduler = TestScheduler(initialClock: 0)
		scheduler.createHotObservable([.next(1, .getPackagesBy(id: 0)) ])
			.bind(to: sut.action)
			.disposed(by: disposeBag)
		
		let response = scheduler.start(
			created: 0,
			subscribed: 0,
			disposed: TestScheduler.Defaults.disposed
		) { [unowned self] in
			self.sut.state
		}
		
		XCTAssertNil(sut.currentState.packages)
		
		let states = response.events.compactMap(\.value.element)
		XCTAssertEqual(
			states.compactMap{ $0.error?.localizedDescription },
			[
				PackagesViewModel.Error.failedGetServerRespond.localizedDescription,
			]
		)
		
	}
}
