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
                    textView.text = "\(weatherResponse.weather.first?.description ?? "N/A")\n\(weatherResponse.main.temp)°C"
                    if let iconName = weatherResponse.weather.first?.icon {
                        if let iconURL = weatherResponse.weather.first?.iconURL {
                            self.loadWeatherIcon(from: iconURL, imageView: iconView)
                        }
                    }
                }
            case .failure(let error):
                print("Weather fetch failed with error: \(error)")
            }
        }
    }

    private func loadWeatherIcon(from url: URL, imageView: UIImageView) {
        // You can use URLSession to fetch the image data and set it to the image view
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error loading icon: \(error)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        task.resume()
    }

    
    //    activityview after refresh
    @IBAction func refreshWeatherData(_ sender: UIButton) {
          // Refresh weather data for both cities
          loadWeatherData(for: "New York", textView: weatherInformationNewYork, iconView: weatherIconNewYork)
          loadWeatherData(for: "Besançon", textView: weatherInformationBesancon, iconView: weatherIconBesancon)
      }
    
}
