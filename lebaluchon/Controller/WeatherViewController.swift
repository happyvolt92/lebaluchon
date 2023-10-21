import UIKit

class WeatherViewController: UIViewController {
    // Outlets
    @IBOutlet weak var weatherInformationNewYork: UITextView!
    
    @IBOutlet weak var weatherIconNewYork: UIImageView!


    @IBOutlet weak var refreshWeatherDataButton: UIButton!
    
    @IBOutlet weak var weatherInformationBesancon: UITextView!
    
    @IBOutlet weak var weatherIconBesancon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load weather data for New York and Besançon with icons
        loadWeatherData(for: "New York", textView: weatherInformationNewYork, iconView: weatherIconNewYork)
        loadWeatherData(for: "Besançon", textView: weatherInformationBesancon, iconView: weatherIconBesancon)
    }
    
    

    private func loadWeatherData(for city: String, textView: UITextView, iconView: UIImageView) {
        WeatherServices.shared.fetchWeather(for: city) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    textView.text = "\(weatherResponse.weather.first?.description ?? "N/A")\n \(weatherResponse.main.temp)°C"
                    if let iconName = weatherResponse.weather.first?.icon {
                        self.loadWeatherIcon(iconName: iconName, imageView: iconView)
                    }
                }
            case .failure(let error):
                print("Weather fetch failed with error: \(error)")
            }
        }
    }
    
    //    activityview after refresh
    @IBAction func refreshWeatherData(_ sender: UIButton) {
          // Refresh weather data for both cities
          loadWeatherData(for: "New York", textView: weatherInformationNewYork, iconView: weatherIconNewYork)
          loadWeatherData(for: "Besançon", textView: weatherInformationBesancon, iconView: weatherIconBesancon)
      }
    
    
    private func loadWeatherIcon(iconName: String, imageView: UIImageView) {
        imageView.image = UIImage(named: iconName)
    }
}
