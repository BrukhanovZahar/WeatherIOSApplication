import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDesriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
    }
    
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateWeatherInfo(latitude: Double, longtitude: Double) {
        NetworkManager.shared.fetchWeatherData(latitude: latitude, longitude: longtitude) { [weak self] weatherData in
            guard let self = self else { return }
            guard let weatherData = weatherData else { return }
            self.weatherData = weatherData
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    func updateView() {
        cityNameLabel.text = weatherData.name
        weatherDesriptionLabel.text = DataSource.weatherIDs[weatherData.weather[0].id]
        temperatureLabel.text = weatherData.main.temp.description + "°"
        
        if let imageName = weatherData.weather.first?.icon,
           let image = UIImage(named: imageName) {
            weatherImageView.image = image
        } else {
            print("Image not found for icon: \(weatherData.weather.first?.icon ?? "unknown")")
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude)
        }
    }
}
