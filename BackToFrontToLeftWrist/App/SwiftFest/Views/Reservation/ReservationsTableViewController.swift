//
//  ReservationsTableViewController.swift
//  SwiftFest
//
//  Created by Matthew Dias on 4/21/18.
//  Copyright © 2018 Matt Dias. All rights reserved.
//

import UIKit

class ReservationsTableViewController: UITableViewController {

    var reservations: [Reservation] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let storedReservations = UserDefaults.standard.array(forKey: "reservations") as? [[String: Any]] else {
            reservations = []
            self.tableView.reloadData()
            return

        }

        for json in storedReservations {
            guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                self.tableView.reloadData()
                return
            }

            if let reservation = try? JSONDecoder().decode(Reservation.self, from: data), !reservations.contains(where: {$0.id == reservation.id}) {
                reservations.append(reservation)
            }
        }

        reservations.sort { $0.date < $1.date }

        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return reservations.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resCell", for: indexPath)

        cell.textLabel?.text = reservations[indexPath.row].restaurant.name
        cell.detailTextLabel?.text = reservations[indexPath.row].date

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController =  segue.destination as? ReservationDetailsViewController {
            let index = tableView.indexPathForSelectedRow?.row
            viewController.reservation = reservations[index!]
        }
    }
}
