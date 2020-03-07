//
//  StationsViewController.swift
//  MediQuoTest
//
//  Created by Filipe on 07/03/2020.
//  Copyright © 2020 Filipe Mota. All rights reserved.
//

import UIKit
import MapKit

class StationsViewController: UIViewController {
    var router: Router!
    private(set) var route: Route!
    private var stationsList: [Detail.Fetch.Station]!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stations"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        configureTableView()
    }

    private func configureTableView() {
        tableView.register(UINib(nibName: "StationCell", bundle: nil), forCellReuseIdentifier: "StationCell")
    }

    @objc private func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension StationsViewController: Routable {
    static func instantiate() -> UIViewController & Routable {
        guard let result = UIStoryboard(name: "Stations", bundle: nil).instantiateInitialViewController() as? StationsViewController else {
            fatalError()
        }
        return result
    }

    func setup(_ route: Route) {
        switch route {
        case .stations(stations: let stations):
            self.route = route
            self.stationsList = stations.sorted(by: { $0.name < $1.name })
        default:
            fatalError()
        }
    }
}

extension StationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let station = stationsList[indexPath.row]

        let latitude: CLLocationDegrees =  station.coordinates.latitude
        let longitude: CLLocationDegrees =  station.coordinates.longitude

        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = station.name
        mapItem.openInMaps(launchOptions: options)
    }
}

extension StationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as? StationCell else {
            fatalError()
        }
        cell.setup(viewModel: stationsList[indexPath.row])
        return cell
    }
}
