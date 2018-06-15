//
//  CreateReservationViewController.swift
//  SwiftFest
//
//  Created by Matthew Dias on 4/15/18.
//  Copyright © 2018 Matt Dias. All rights reserved.
//

import UIKit

class CreateReservationViewController: UIViewController {

    weak var delegate: CreateReservationDelegate?
    var restaurantId = -1

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var partySizeTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!

    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "MM/dd/yyyy, HH:mm"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        partySizeTextField.becomeFirstResponder()
    }
    
    func togglePicker() {
        self.datePicker.isHidden = !datePicker.isHidden

        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }

    @IBAction func tappedReserve(_ sender: Any) {
        dateTextField.resignFirstResponder()
        partySizeTextField.resignFirstResponder()
        togglePicker()

        var request = URLRequest(url: URL(string: "http://\(baseURL):8080/reservation")!)
        request.httpMethod = "POST"
        request.httpBody = getPayload()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { self.displayError(message: error!.localizedDescription); return }

            guard let httpResponse = response as? HTTPURLResponse else { return }

            if httpResponse.statusCode == 200 {
                let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String: Any]
                self.save(reservation: json!)
                self.changeToReservationsTab()
            } else {
                let message = String(data: data!, encoding: .utf8)!
                self.displayError(message: message)
            }
        }

        task.resume()
    }

    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func displayError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Network error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            self.show(alert, sender: nil)
        }
    }

    func getPayload() -> Data {
        var payload = [String: Any]()
        payload["restaurantId"] = restaurantId
        payload["partySize"] = Int(partySizeTextField.text!)!
        payload["date"] = dateTextField.text

        return try! JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
    }

    func save(reservation: [String: Any]) {
        var allReservations = UserDefaults.standard.array(forKey: "reservations") ?? [[String: Any]]()
        allReservations.append(reservation)
        UserDefaults.standard.set(allReservations, forKey: "reservations")
    }

    func changeToReservationsTab() {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let tabBar = appDelegate.window?.rootViewController as! UITabBarController
            tabBar.selectedIndex = 1

            self.delegate?.pop()
            self.dismiss(animated: false, completion: nil)
        }
    }
}

extension CreateReservationViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField == dateTextField {
            partySizeTextField.resignFirstResponder()
            togglePicker()
            return false
        }
        
        return true
    }
}
