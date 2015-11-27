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
    var weatherMap: AWFWeatherMap!
    var mapLegend: AWFWeatherMapLegendView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let aerisConsumerId: String! = "Wu2WiydcDfv8EOkZ8U6J2"
        let aerisConsumerSecret: String! = "FjJ4vGVobaGUpUJwsISwbbmh70l7Y9j7CJNPVLNf"
        AerisEngine.engineWithKey(aerisConsumerId, secret: aerisConsumerSecret)
        AerisEngine.debugDescription()
        
        let location = CLLocation(latitude: data["latitude"] as! Double, longitude: data["longitude"] as! Double)
        
        self.weatherMap = AWFWeatherMap(mapType: AWFWeatherMapType.Apple)
        self.weatherMap.weatherMapView.frame = CGRectMake(0, 115, self.view.bounds.width, self.view.bounds.height - 115)
        self.weatherMap.setMapCenterCoordinate(location.coordinate, zoomLevel: 11, animated: true)
        
        self.weatherMap.addLayerType(AWFLayerType.Radar)
        self.weatherMap.addLayerType(AWFLayerType.Satellite)
        
        self.mapLegend = AWFWeatherMapLegendView(mapConfig: weatherMap.config, frame: CGRectMake(0, 64, self.view.bounds.width, 10))
        self.mapLegend.addLegendForLayerType(AWFLayerType.Radar)
        self.mapLegend.sizeToFit()
        
        self.view.addSubview(weatherMap.weatherMapView)
        self.view.addSubview(mapLegend)
        
    }
    
//    func centerMapOnLocation(location: CLLocation) {
//        let regionRadius: CLLocationDistance = 9000
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//            regionRadius, regionRadius)
//        self.weatherMap.setRegion(coordinateRegion, animated: true)
//        addAnnotation(location)
//    }
//    
//    func addAnnotation(location: CLLocation) {
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location.coordinate
//        self.weatherMapKit.addAnnotation(annotation)
//    }
}
