//
//  PageViewController.swift
//  RealWeatherAppVer1
//
//  Created by jhchoi on 2023/07/17.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var viewsList: [UIViewController]
    
//    var cityNames: [String]
    
//    init(viewList: [UIViewController], cityNames: [String], cityName: String) {
        init(viewList: [UIViewController]) {
        
//        self.cityNames = cityNames
        self.viewsList = viewList
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        
//        for cityName in cityNames {
//            let resultViewController = ResultViewController(cityName: cityName)
//            resultViewController.getWeather(cityName: cityName)
//            resultViewController.getWeatherKeyValue()
//            viewsList.append(resultViewController)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let vc = viewsList.first {
            self.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    // 이전 페이지 이동
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 현재 페이지의 뷰 컨트롤러(viewController)가 viewsList 배열의 몇 번째 요소인지 확인합니다.
        // 만약 뷰 컨트롤러가 배열에 존재하지 않는다면(lastIndex(of:)의 반환 값이 nil), nil을 반환하여 이전 페이지가 없음을 알립니다.
        guard let index = viewsList.lastIndex(of: viewController) else { return nil }
        
        // 이전 페이지의 인덱스
        let previousIndex = index - 1
        
        // 이전 페이지의 인덱스(previousIndex)가 0보다 작거나 같은지 확인합니다.
        // 0보다 작거나 같다면, 이전 페이지가 없으므로(viewsList 배열의 첫 번째 요소 이전을 나타내는 인덱스는 없음), nil을 반환하여 이전 페이지가 없음을 알립니다.
        guard previousIndex >= 0 else {return nil}
        
        // 이전 페이지의 인덱스(previousIndex)가 viewsList 배열의 유효한 범위 내에 있는지 확인합니다.
        // 유효한 범위를 벗어난다면, 이전 페이지가 없으므로(viewsList 배열의 마지막 요소 이후를 나타내는 인덱스는 없음), nil을 반환하여 이전 페이지가 없음을 알립니다.
        guard previousIndex < viewsList.count else {return nil}
        return viewsList[previousIndex]
    }
    
    // 다음 페이지 이동
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewsList.lastIndex(of: viewController) else { return nil }
                let previousIndex = index + 1
                guard previousIndex >= 0 else {return nil}
                guard previousIndex < viewsList.count else {return nil}
                return viewsList[previousIndex]
    }
}

