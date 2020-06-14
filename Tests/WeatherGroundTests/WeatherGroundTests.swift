import Foundation
import XCTest
@testable import WeatherGround

final class WeatherGroundTests: XCTestCase {
    override static func setUp() {
        if let apiKey = ProcessInfo.processInfo.environment["APIKEY"] {
            WeatherGround.measure.apiKey = apiKey
        }
        if let station = ProcessInfo.processInfo.environment["STATION"] {
            WeatherGround.measure.station = station
        }
    }

    func testBase() {
        XCTAssertNotEqual(WeatherGround.measure.apiKey, "")
        XCTAssertNotEqual(WeatherGround.measure.station, "")
    }

    func testRetrieveCurrent() {
        let expectation = XCTestExpectation(description: #function)
        WeatherGround.measure.current(){ history in 
            defer{ expectation.fulfill() }
            guard case .success = history else {
                XCTFail("Unable to retrieve the observation.")
                return
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testRetrieveHourly() {
        let expectation = XCTestExpectation(description: #function)
        WeatherGround.measure.hourly(for: Date()){ history in 
            defer{ expectation.fulfill() }
            guard case .success(let observations) = history else {
                XCTFail("Unable to retrieve the observations.")
                return
            }
            XCTAssertNotEqual(observations.count, 0)
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testRetrieveDaily() {
        let expectation = XCTestExpectation(description: #function)
        WeatherGround.measure.daily(for: Date()){ history in
            defer{ expectation.fulfill() }
            guard case .success = history else {
                XCTFail("Unable to retrieve the observation.")
                return
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testRetrieveHistory() {
        let expectation = XCTestExpectation(description: #function)
        WeatherGround.measure.all(for: Date()){ history in
            defer{ expectation.fulfill() }
            guard case .success(let observations) = history else {
                XCTFail("Unable to retrieve the observations.")
                return
            }
            XCTAssertNotEqual(observations.count, 0)
        }
        wait(for: [expectation], timeout: 10.0)
    }

    static var allTests = [
        ("testBase", testBase),
        ("testRetrieveCurrent", testRetrieveCurrent),
        ("testRetrieveHourly", testRetrieveHourly),
        ("testRetrieveDaily", testRetrieveDaily),
        ("testRetrieveHistory", testRetrieveHistory),
    ]
}
