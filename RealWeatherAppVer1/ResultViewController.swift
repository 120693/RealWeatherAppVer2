//
//  ResultViewController.swift
//  RealWeatherAppVer1
//
//  Created by jhchoi on 2023/07/17.
//

import UIKit
import Kingfisher

public func kToC(kelvin: Double) -> String {
    let celsius: Double
    let result: String
    
    celsius = kelvin - 273.15
    
    result = String(format:"%.2f", celsius) + "°C"
    
    return result
}

class ResultViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var weatherInfo: [String:Any]?
    
    var weatherKeys: [String] = ["name","week","coord","main", "weather","wind"]
    var weatherValues: [Any] = []
    
    var mainDict: [String: Any] = [:]
    var windDict: [String: Any] = [:]
    var weatherDict: [String: Any] = [:]
    var coordDict: [String: Any] = [:]
    
    var dayName: [String] = ["월","화","수","목","금","토","일"]
    var dayIcon: [String] = ["10d","01d","02d","03d","04d","11d","13d"]
    
    var cityName: String
    
    init(cityName: String) {
        self.cityName = cityName
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeatherKeyValue()
        
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        tableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderView")
//        tableView.register(UINib(nibName: "WeekTableViewCell", bundle: nil), forCellReuseIdentifier: "WeekTableViewCell")
//        tableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionTableViewCell")
//        tableView.register(UINib(nibName: "FooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "FooterView")
////         Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderView")
        tableView.register(UINib(nibName: "WeekTableViewCell", bundle: nil), forCellReuseIdentifier: "WeekTableViewCell")
        tableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionTableViewCell")
        tableView.register(UINib(nibName: "FooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "FooterView")
    }
    
    func getWeatherKeyValue() {
        
        if let weatherInfo = weatherInfo {
            for (_ , value) in weatherInfo {
                weatherValues.append(value)
                //print(value)
            }
        }
        
        if let dictionary = weatherInfo,
           let mainDictionary = dictionary["main"] as? [String: Any],
           let windDictionary = dictionary["wind"] as? [String: Any],
           let coordDictionary = dictionary["coord"] as? [String: Any],
           let weatherArray = dictionary["weather"] as? [Any],
           let weatherDictionary = weatherArray.first as? [String: Any] {
            mainDict = mainDictionary
            windDict = windDictionary
            coordDict = coordDictionary
            
            var weatherValues: [String: Any] = [:]
                for (key, value) in weatherDictionary {
                    weatherValues[key] = value
                }
            weatherDict = weatherValues
        }
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return dayName.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
        
        if section == 0 {
            if let name = weatherInfo?["name"] as? String {
                view.cityNameLabel.text = name
            }
            
            if let temp = mainDict["temp"] as? Double {
                view.feelTempLabel.text = kToC(kelvin: temp)
            }
            
            if let icon = weatherDict["icon"] as? String {
                guard let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { return nil }
                view.iconImageView.kf.setImage(with: url)
                view.iconImageView.contentMode = .scaleAspectFill
            }
            
            if let maxTemp = mainDict["temp_max"] as? Double {
                view.maxTempLabel.text = "최고:" + kToC(kelvin: maxTemp)
            }
            
            if let minTemp = mainDict["temp_min"] as? Double {
                view.minTempLabel.text = "최저:" + kToC(kelvin: minTemp)
            }
            
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "7일간의 일기예보"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == 0 {
            return 250
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FooterView") as! FooterView
            
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        if section == 0 {
            
            return 160
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
            
            cell.mainData(with: mainDict)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeekTableViewCell", for: indexPath) as! WeekTableViewCell
            
            cell.dayName.text = dayName[indexPath.row]
            
            guard let url = URL(string: "https://openweathermap.org/img/wn/\(dayIcon[indexPath.row])@2x.png") else { return cell}
            
            cell.dayIcon.kf.setImage(with: url)
            cell.dayIcon.contentMode = .scaleAspectFill

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else {
            return UITableView.automaticDimension
        }
    }
}
