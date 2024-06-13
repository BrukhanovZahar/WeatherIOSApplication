import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (WeatherData?) -> Void) {
        
        let apiKey = APIKey.weatherAPIKey
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&lang=ru&appid=\(apiKey)")
        else {
            print("URL error")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("DataTask error: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(weatherData)
            } catch {
                print("JSON Decoding error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
