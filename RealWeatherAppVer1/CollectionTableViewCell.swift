//
//  CollectionTableViewCell.swift
//  RealWeatherAppVer1
//
//  Created by jhchoi on 2023/07/17.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let titlesList = ["🌡️체감온도", "💧습도", "⬇️최저기온", "⬆️최고기온"]
    
    var feelsLikeData: String?
    var humidityData: String?
    var minTempData: String?
    var maxTempData: String?
            
    var spacing: CGFloat = 10.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func mainData(with data: [String: Any]) {
        if let feelsLike = data["feels_like"] as? Double {
            feelsLikeData = kToC(kelvin: feelsLike)
        }
        
        if let humidity = data["humidity"] as? Double {
            humidityData = String(humidity) + "%"
        }
        
        if let minTemp = data["temp_min"] as? Double {
            minTempData = kToC(kelvin: minTemp)
        }
        
        if let maxTemp = data["temp_max"] as? Double {
            maxTempData = kToC(kelvin: maxTemp)
        }
    }
    
}

extension CollectionTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.titleLabel.text = titlesList[indexPath.row]
        

        if titlesList[indexPath.row] == "🌡️체감온도" {
            cell.contentLabel.text = feelsLikeData
        }
        
        if titlesList[indexPath.row] == "💧습도" {
            cell.contentLabel.text = humidityData
        }
        
        if titlesList[indexPath.row] == "⬇️최저기온" {
            cell.contentLabel.text = minTempData
        }
        
        if titlesList[indexPath.row] == "⬆️최고기온" {
            cell.contentLabel.text = maxTempData
        }
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.systemGray4.cgColor
        cell.layer.borderWidth = 2.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let width = (collectionView.bounds.width - spacing * 3) / 2
        
        return CGSize(width: width, height: 150)
    }
}
