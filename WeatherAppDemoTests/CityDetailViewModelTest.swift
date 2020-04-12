import XCTest
@testable import WeatherAppDemo

class CityDetailViewModelTest: XCTestCase {
    
    private var expectation: XCTestExpectation?
    private var viewModel: CityDetailViewModel?

    override func setUp() {
        super.setUp()
        ServiceConfiguration.sessionManager = mockSessionManager
        self.viewModel = CityDetailViewModel()
    }
    
    func testLoadCityDataWithSuccessResponse() {
        var result: Error?
        guard let data = jsonToData(path: "getCityWeatherResponseStub", extension: "json") else { return }
        self.expectation = makeExpectation(#function)
        MockURLProtocol.responseWithStatusCode(code: 200, data: data)
        
        self.viewModel?.loadCityData(cityId: 1) { (error, _) in
            result = error
            self.expectation?.fulfill()
        }
        
        wait(for: [self.expectation!], timeout: expectationTimeout)
        XCTAssertNil(result)
    }
    
    func testLoadCityDataWithBackendError() {
        var result: Error?
        self.expectation = makeExpectation(#function)
        MockURLProtocol.responseWithStatusCode(code: 400, data: nil)
        
        self.viewModel?.loadCityData(cityId: 1) { (error, _) in
            result = error
            self.expectation?.fulfill()
        }
        
        wait(for: [self.expectation!], timeout: expectationTimeout)
        XCTAssertNotNil(result)
    }
    
    func testLoadWeatherIcon() throws {
        let codeStr = "hello"
        
        let iconURL = try self.viewModel?.loadWeatherIcon(codeStr: codeStr)
        
        XCTAssertNotNil(iconURL)
    }

    override func tearDown() {

    }

}
