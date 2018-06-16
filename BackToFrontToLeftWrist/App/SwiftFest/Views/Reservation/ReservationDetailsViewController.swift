//
//  ReservationDetailsViewController.swift
//  SwiftFest
//
//  Created by Matt Dias on 4/28/18.
//  Copyright © 2018 Matt Dias. All rights reserved.
//

import UIKit
import MapKit

class ReservationDetailsViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var partySizeLabel: UILabel!
    @IBOutlet var reservationTimeLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var websiteButton: UIButton!
    @IBOutlet var phoneButton: UIButton!
    
    var reservation: Reservation?
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = reservation?.restaurant.name
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
        
        if let reservation = reservation {
            let restaurant = reservation.restaurant
            
            titleLabel.text = restaurant.name
            partySizeLabel.text = "Party of: \(reservation.partySize)"
            reservationTimeLabel.text = "Reserved for: \(reservation.date)"
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

    @IBAction func cancelTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Cancel Reservation", message: "Are you sure you want to cancel your reservation?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes, cancel", style: .destructive, handler: { _ in
            self.cancelReservation()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func cancelReservation() {
        var request = URLRequest(url: URL(string: "http://\(baseURL):8080/reservation/\(reservation!.id)")!)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { print(error.debugDescription); return}

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 400  else { print(response.debugDescription); return}
            
            if var storedReservations = UserDefaults.standard.array(forKey: "reservations") as? [[String: Any]] {
                if storedReservations.count == 1 {
                    UserDefaults.standard.removeObject(forKey: "reservations")
                } else {
                    for (index, res) in storedReservations.enumerated() {
                        if res["id"] as? Int == self.reservation!.id {
                            storedReservations.remove(at: index)
                        }
                    }
                    UserDefaults.standard.set(storedReservations, forKey: "reservations")

                }

                DispatchQueue.main.async {
                    UserDefaults.standard.synchronize()
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        task.resume()
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

extension ReservationDetailsViewController: CLLocationManagerDelegate { }

extension ReservationDetailsViewController: MKMapViewDelegate { }
