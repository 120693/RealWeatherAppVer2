//
//  ViewController.swift
//  RealWeatherAppVer1
//
//  Created by jhchoi on 2023/07/14.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "실시간 날씨 정보"
        cityNameTextField.text = "Seoul, Gwangju"
    }

    @IBAction func resultButton(_ sender: Any) {
        if let input = cityNameTextField.text {
            
            
            let trimmedInput = input.replacingOccurrences(of: " ", with: "")
            let cityNames = trimmedInput.components(separatedBy: ",")
//            var viewsList: [UIViewController] = []
            getWeather(cityNames: cityNames)
//            for cityName in cityNames {
//                let resultViewController = ResultViewController(cityName: cityName)
//                resultViewController.getWeather(cityName: cityName)
//                resultViewController.getWeatherKeyValue()
//                viewsList.append(getWeather(cityName: cityName))
//            }
            
//            let mediumViewController = MediumViewController()
//            self.navigationController?.pushViewController(mediumViewController, animated: true)
        }
    }
    
    func getWeather(cityNames: [String]) {
        Task {
            var viewsList: [UIViewController] = []
            for cityName in cityNames {
                // 이러면 스토리보드에서 가져오는 것이 아니라 아예 새로 만든다ㅠㅠㅠㅠ
                //let resultViewController = ResultViewController(cityName: cityName)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                if let resultViewController = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
                    let weatherModel = try await sss(cityName: cityName)
                    resultViewController.weatherInfo = weatherModel
                    
                    viewsList.append(resultViewController)
                }
            }
            
            
            let pageViewController = PageViewController(viewList: viewsList)
            self.navigationController?.pushViewController(pageViewController, animated: true)
        }
            
//        session.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else { return }
//            let decoder = JSONDecoder()
//            guard let weatherModel = try? decoder.decode(WeatherModel.self, from: data) else { return }
//            // debugPrint(weatherModel)
//            guard let weatherDictionary = self.encodeModelToDictionary(model: weatherModel) else { return }
//
//            resultViewController.weatherInfo = weatherDictionary
//            debugPrint(weatherDictionary)
//
//            // 메인 스레드에서 작업
////            DispatchQueue.main.async {
////                self.navigationController?.pushViewController(resultViewController, animated: true)
////            }
//        }.resume()
    }
    
    func encodeModelToDictionary<T: Codable>(model: T) -> [String: Any]? {
        guard let jsonData = try? JSONEncoder().encode(model) else {
               return nil
           }
        guard let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
               return nil
           }
        return dictionary
    }
    
    func sss(cityName: String) async throws -> [String: Any] {
        var components = URLComponents()
        
        let scheme = "https"
        let host = "api.openweathermap.org"
        let apiKey = "a8c1d55d8c112dbe5f0576f243f507ac"
        
        components.scheme = scheme
        components.host = host
        components.path = "/data/2.5/weather"
        components.queryItems = [URLQueryItem(name: "q", value: cityName), URLQueryItem(name: "appid", value: apiKey)]
        
        let url = components.url!
        
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
        
        let (data,response) = try await session.data(for: request)
        
        
        let decoder = JSONDecoder()
        let weatherModel = try? decoder.decode(WeatherModel.self, from: data)
        // debugPrint(weatherModel)
        let weatherDictionary = self.encodeModelToDictionary(model: weatherModel)

        return weatherDictionary!
    }
}

