//
//  FooterView.swift
//  RealWeatherAppVer1
//
//  Created by jhchoi on 2023/07/17.
//

import UIKit

class FooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var spacing: CGFloat = 10.0
    
    override func awakeFromNib() {
        collectionView.register(UINib(nibName: "FooterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FooterCollectionViewCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

}
extension FooterView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FooterCollectionViewCell", for: indexPath) as! FooterCollectionViewCell
        
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.systemGray4.cgColor
        cell.layer.borderWidth = 2.0
        
        switch indexPath.row  {
        case 0:
            cell.titleLabel.text = " 👀 가시거리"
            cell.contentLabel.text = "16KM"
            return cell
        case 1:
            cell.titleLabel.text = " ☀️ 자외선 지수"
            cell.contentLabel.text = "낮음"
            return cell
        case 2:
            cell.titleLabel.text = " 🌇 일몰"
            cell.contentLabel.text = "오후 7시 56분"
            return cell
        case 3:
            cell.titleLabel.text = " 🌬️ 대기질"
            cell.contentLabel.text = "보통"
            return cell
        default:
            return UICollectionViewCell()
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width - spacing*3) / 2
        
        return CGSize(width: width, height: 150)
    }
}
