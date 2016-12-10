//
//  FoodViewController.swift
//  First App
//
//  Created by Theodore Ando on 12/9/16.
//  Copyright © 2016 Theodore Ando. All rights reserved.
//

import UIKit
import MapKit

class FoodViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var foodResult: FoodResult!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var emailText: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("View did load...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let foodLocationCoord = CLLocationCoordinate2D(latitude: CLLocationDegrees(foodResult.latitude), longitude: CLLocationDegrees(foodResult.longitude))
        mapView.region = MKCoordinateRegionMakeWithDistance(
            foodLocationCoord,
            CLLocationDistance(500), CLLocationDistance(500)
        )
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.showsBuildings = true
        mapView.camera.pitch = 10.0
        
        print("Attempting to set point...")
        let point = MKPointAnnotation()
        point.coordinate = foodLocationCoord
        point.title = foodResult.locationName
        mapView.addAnnotation(point)
        locationLabel.text = foodResult.locationName
        emailText.text = foodResult.emailText
        emailText.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
