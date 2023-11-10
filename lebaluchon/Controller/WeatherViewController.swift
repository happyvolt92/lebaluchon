import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var weatherInformationNewYork: UITextView!
    @IBOutlet weak var weatherIconNewYork: UIImageView!
    @IBOutlet weak var refreshWeatherDataButton: UIButton!
    @IBOutlet weak var weatherInformationBesancon: UITextView!
    @IBOutlet weak var weatherIconBesancon: UIImageView!

    @IBAction func refreshWeatherData(_ sender: UIButton) {
        loadWeatherData(for: "New York", textView: weatherInformationNewYork, iconView: weatherIconNewYork)
        loadWeatherData(for: "Besançon", textView: weatherInformationBesancon, iconView: weatherIconBesancon)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
                    if let iconURL = weatherResponse.weather.first?.iconURL {
                        self.loadWeatherIcon(from: iconURL, imageView: iconView)
                    }
                }
            case .failure(let error):
                self.showAlert(for: error)
            }
        }
    }

    private func loadWeatherIcon(from url: URL, imageView: UIImageView) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.showAlert(for: .requestError)
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
}
