//
//  RestaurantDetailViewController.swift
//  SwiftFest
//
//  Created by Matthew Dias on 10/30/17.
//  Copyright © 2017 Matt Dias. All rights reserved.
//

import UIKit
import MapKit

protocol CreateReservationDelegate: class {
    func pop()
}

class RestaurantDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!

    var restaurant: Restaurant?
    var locationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self

        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }

        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }

        if let restaurant = restaurant {
            titleLabel.text = restaurant.name
            websiteButton.setTitle(restaurant.website, for: .normal)
            phoneButton.setTitle(restaurant.phoneNumber, for: .normal)
            getAdressName(location: CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude))

            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            self.mapView.addAnnotation(pin)

            let viewRegion = MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            self.mapView.setRegion(viewRegion, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let controller = segue.destination as? CreateReservationViewController {
            controller.restaurantId = restaurant?.id ?? -1
            controller.delegate = self
        }
    }

    private func getAdressName(location: CLLocation) {

        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            guard error == nil else {
                print("\(error!)")
                return
            }

            if let place = placemarks?[0] {

                guard let streetNumber = place.subThoroughfare,
                      let street = place.thoroughfare,
                      let city = place.locality else { return }

                self.addressLabel.text = "\(streetNumber) \(street), \(city)"
            }
        }
    }

}

extension RestaurantDetailViewController: CreateReservationDelegate {
    func pop() {
        self.navigationController?.popToRootViewController(animated: false)
    }
}

extension RestaurantDetailViewController: CLLocationManagerDelegate { }

extension RestaurantDetailViewController: MKMapViewDelegate { }
