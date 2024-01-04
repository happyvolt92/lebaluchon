import UIKit


class WeatherViewController: UIViewController {
    // Outlets
    @IBOutlet weak var weatherInformationNewYork: UITextView!
    @IBOutlet weak var weatherIconNewYork: UIImageView!
    @IBOutlet weak var refreshWeatherDataButton: UIButton!
    @IBOutlet weak var weatherInformationBesancon: UITextView!
    @IBOutlet weak var weatherIconBesancon: UIImageView!

    // Action when the refresh button is tapped
    @IBAction func refreshWeatherData(_ sender: UIButton) {
        // Load weather data for New York and Besançon
        loadWeatherData(for: "New York", textView: weatherInformationNewYork, iconView: weatherIconNewYork)
        loadWeatherData(for: "Besançon", textView: weatherInformationBesancon, iconView: weatherIconBesancon)
    } 

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Function to load weather data for a given city
     func loadWeatherData(for city: String, textView: UITextView, iconView: UIImageView) {
        // Call the weather service to fetch weather data
        WeatherServices.shared.fetchWeather(for: city) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    // Update the weather information in the text view
                    textView.text = "\(weatherResponse.weather.first?.description ?? "N/A")\n\(weatherResponse.main.temp)°C"
                    // Load and display the weather icon
                    if let iconURL = weatherResponse.weather.first?.iconURL {
                        self.loadWeatherIcon(from: iconURL, imageView: iconView)
                    }
                }
            case .failure(let error):
                // Show an alert for weather data fetch failure
                self.showAlert(for: error)
            }
        }
    }

    // Function to load and display the weather icon
    private func loadWeatherIcon(from url: URL, imageView: UIImageView) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                // Show an alert for icon loading failure
                self.showAlert(for: .requestError)
                print("Error loading icon: \(error)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    // Display the loaded weather icon
                    imageView.image = image
                }
            }
        }
        task.resume()
    }
}
