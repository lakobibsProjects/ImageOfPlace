//
//  ImageOfPlaceTabBar.swift
//  ImageOfPlace
//
//  Created by user166683 on 1/14/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import UIKit

class ImageOfPlaceTabBar: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let newtworkAlbums = NetworkAlbumsViewController()
        let networkAlbumsItem = UITabBarItem(title: "", image: UIImage(named: "AddListIcon"), tag: 0)
        newtworkAlbums.tabBarItem = networkAlbumsItem
        
        let savedAlbums = SavedAlbumsViewController()
        let savedAlbumsItem = UITabBarItem(title: "", image: UIImage(named: "MemoryIcon"), tag: 1)
        savedAlbums.tabBarItem = savedAlbumsItem
        
        let geolocation = GeolocationViewController()
        let geolocationItem = UITabBarItem(title: "", image: UIImage(named: "LocationIcon"), tag: 2)
        geolocation.tabBarItem = geolocationItem
        
        let controllers = [newtworkAlbums, savedAlbums, geolocation]
        self.viewControllers = controllers
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true;
    }
}
