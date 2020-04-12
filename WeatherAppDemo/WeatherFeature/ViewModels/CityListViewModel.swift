import Foundation

class CityListViewModel {

    var filteredCities: [City] = []
    var cities: [City] = []

    func getCities() -> [City] {
        guard
            let url = Bundle.main.url(forResource: "cities", withExtension: "json"),
            let data = try? Data(contentsOf: url)
            else {
                return []
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([City].self, from: data)
        } catch {
            return []
        }
    }

    func processfilterCities(_ cities: [City], searchText: String) {
        self.filteredCities = cities.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
}
