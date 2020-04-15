import UIKit

class CityDetailViewController: UIViewController {
    
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var currentWeatherLabel: UILabel!  
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var weatherImageView: UIImageView!
    
    public var cityID: Int!
    public var cityName: String!
    
    var viewModel: CityDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        viewModel?.loadCityData(cityId: Int(cityID)) { [weak self] (_, weatherResp) in
            guard let weather = weatherResp else { return }
            self?.configureViewComponent(weather)
        }
    }
    
    func configureViewComponent(_ weather: GetCityWeatherResponse) {
        guard let tempInt = weather.main?.temp else { return }
        var temp = String(tempInt)
        temp.append("˚")
        tempLabel.text = temp
        currentWeatherLabel.text = weather.weather?.first?.description
        guard let iconCodeStr = weather.weather?.first?.icon else { return }
        let iconURL = try! self.viewModel?.loadWeatherIcon(codeStr: iconCodeStr)
//        weatherImageView.kf.setImage(with: iconURL)
        weatherImageView.loadURL(url: iconURL)
        print("demo1 iconURL: \(iconURL?.absoluteString)")
    }
    
    func configureView() {
        self.cityLabel.text = cityName
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderWidth = 0
        self.containerView.layer.shadowColor = UIColor.black.cgColor
        self.containerView.layer.shadowRadius = 4
        self.containerView.layer.shadowOpacity = 0.2
        self.containerView.layer.shadowOffset = CGSize(width: -1.0, height: 1.0)
        self.containerView.backgroundColor = UIColor.lightGray
    }


}
