//
//  MapViewController.swift
//  Sickle
//
//  Created by Tushar Tiwari on 11/25/15.
//  Copyright © 2015 Sickle Inc. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var data: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocation(latitude: data["latitude"] as! Double, longitude: data["longitude"] as! Double)
        
        let aerisConsumerId: String! = "Wu2WiydcDfv8EOkZ8U6J2"
        let aerisConsumerSecret: String! = "FjJ4vGVobaGUpUJwsISwbbmh70l7Y9j7CJNPVLNf"
        
        AerisEngine.engineWithKey(aerisConsumerId, secret: aerisConsumerSecret)
        
        let weatherMap: AWFWeatherMap = AWFWeatherMap(mapType: AWFWeatherMapType.Apple)
        weatherMap.config.animationEnabled = true
        weatherMap.weatherMapView.frame = self.view.bounds
        weatherMap.setMapCenterCoordinate(location.coordinate, zoomLevel: 11, animated: true)
        weatherMap.addLayerType(AWFLayerType.Radar)
        weatherMap.addLayerType(AWFLayerType.Satellite)
        let mapLegend: AWFWeatherMapLegendView = AWFWeatherMapLegendView()
        mapLegend.addLegendForLayerType(AWFLayerType.Radar)
        mapLegend.addLegendForLayerType(AWFLayerType.Satellite)
        mapLegend.sizeToFit()
        self.view.addSubview(weatherMap.weatherMapView)
        self.view.addSubview(mapLegend)
        
    }
    
//    func centerMapOnLocation(location: CLLocation) {
//        let regionRadius: CLLocationDistance = 9000
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//            regionRadius, regionRadius)
//        self.weatherMapKit.setRegion(coordinateRegion, animated: true)
//        addAnnotation(location)
//    }
//    
//    func addAnnotation(location: CLLocation) {
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location.coordinate
//        self.weatherMapKit.addAnnotation(annotation)
//    }
}
