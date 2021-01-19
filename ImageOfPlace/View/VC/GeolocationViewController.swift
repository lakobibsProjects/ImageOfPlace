//
//  GeolocationViewController.swift
//  ImageOfPlace
//
//  Created by user166683 on 1/14/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation

class GeolocationViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    private var lastLocation =  CLLocation()
    private var locationIsShowed = false
    
    var locationText: UITextView!
    var getLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    //MARK: - Support Functions
    ///setup all views
    private func setup(){
        initViews()
        setupViews()
        setupConstraints()
    }
    
    private func initViews(){
        locationText = UITextView()
        locationText.textColor = .green
        
        getLocationButton = UIButton()
        getLocationButton.setTitle("Look your location", for: .normal)
        getLocationButton.setTitleColor(.green, for: .normal)
        
        getLocationButton.addTarget(self, action: #selector(getLocationButtonClicked), for: .touchUpInside)
        
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: - Event Handlers
    @objc private func getLocationButtonClicked(){
        if locationIsShowed{
            locationManager.stopUpdatingLocation()
            locationText.text = ""
            getLocationButton.setTitle("Look your location", for: .normal)
            locationIsShowed = !locationIsShowed
        } else{
            locationManager.startUpdatingLocation()
            locationText.text = "Your location: \nLatitude: \(lastLocation.coordinate.latitude)\nLongtitude: \(lastLocation.coordinate.longitude)"
            getLocationButton.setTitle("Stop looking location", for: .normal)
            locationIsShowed = !locationIsShowed
        }        
    }
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            lastLocation = location
        }
    }
}

//MARK: - Layout
extension GeolocationViewController {
    private func setupViews(){
        self.view.addSubview(locationText)
        self.view.addSubview(getLocationButton)
    }
    
    private func setupConstraints(){
        locationText.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview().offset(48)
            $0.height.equalTo(128)
        })
        
        getLocationButton.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(locationText.snp.bottom).offset(16)
            $0.height.equalTo(48)
        })
    }
}
