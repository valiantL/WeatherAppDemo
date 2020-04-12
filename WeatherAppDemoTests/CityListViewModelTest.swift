import XCTest
@testable import WeatherAppDemo


class CityListViewModelTest : XCTestCase {
    
    private var cities: [City]!
    private var viewModel: CityListViewModel?
    
    override func setUp() {
        super.setUp()
        self.viewModel = CityListViewModel()
    }
    
    func testGetCities() {
        self.cities = self.viewModel?.getCities()
        XCTAssertTrue(self.cities.count > 0, "cities is not empty")
    }
    
    func testProcessfilterCities() {
        let str = "hello"
        guard let cityList = self.viewModel?.getCities() else { return }
        self.viewModel?.processfilterCities(cityList, searchText: str)
        
        XCTAssertTrue((self.viewModel?.filteredCities.count)! > 0, "cities is not empty")
    }
}
