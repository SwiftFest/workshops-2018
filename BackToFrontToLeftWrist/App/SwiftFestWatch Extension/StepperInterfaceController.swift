//
//  StepperInterfaceController.swift
//  SwiftFestWatch Extension
//
//  Created by Matt Dias on 5/20/18.
//  Copyright © 2018 Matt Dias. All rights reserved.
//

import WatchKit
import Foundation

typealias EditObject = (usage: String, reservation: Reservation)

class StepperInterfaceController: WKInterfaceController {

    var usage: String?
    var reservation: Reservation?
    let dateFormatter = DateFormatter()

    @IBOutlet var valueLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }


    @IBAction func plusTapped() {
        guard reservation != nil else { return }

        if usage == "party" {
            reservation?.partySize += 1
            valueLabel.setText("\(reservation!.partySize)")
        } else if usage == "time" {
            let reservationDate = dateFormatter.date(from: reservation!.date)!
            var components = Calendar.current.dateComponents([.month, .day, .year, .hour, .minute], from: reservationDate)
            if components.minute! + 1 % 60 <= 59 {
                components.minute! += 1
            } else {
                components.minute! = 0
                components.hour! += 1
            }
            reservation?.date = "\(components.month!)/\(components.day!)/\(components.year!), \(components.hour!):\(components.minute!)"
            valueLabel.setText("\(components.hour!):\(components.minute!)")
        }
    }

    @IBAction func minusTapped() {
        guard reservation != nil, reservation!.partySize >= 1 else { return }

        if usage == "party" {
            reservation?.partySize -= 1
            valueLabel.setText("\(reservation!.partySize)")
        } else if usage == "time" {
            let reservationDate = dateFormatter.date(from: reservation!.date)!
            var components = Calendar.current.dateComponents([.month, .day, .year, .hour, .minute], from: reservationDate)
            if components.minute! - 1 % 60 >= 1 {
                components.minute! -= 1
            } else if components.hour! - 1 % 24 >= 1 {
                components.minute! = 0
                components.hour! -= 1
            }
            reservation?.date = "\(components.month!)/\(components.day!)/\(components.year!), \(components.hour!):\(components.minute!)"
            valueLabel.setText("\(components.hour!):\(components.minute!)")
        }
    }
}
