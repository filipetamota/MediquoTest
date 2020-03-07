//
//  DetailViewController.swift
//  MediQuoTest
//
//  Created by Filipe on 07/03/2020.
//  Copyright (c) 2020 Filipe Mota. All rights reserved.
//

import UIKit
import MapKit

protocol DetailDisplayLogic: class {
  func displayData(data: Detail.Fetch.ViewModel?, error: Error?)
}

class DetailViewController: UIViewController, DetailDisplayLogic, APIClientDependency {
    var api: APIClient!
    var router: Router!
    private(set) var route: Route!
    var interactor: DetailBusinessLogic?
    private var detailRoute: String!
    private var data: Detail.Fetch.ViewModel?

    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var stationsLabel: UILabel!
    @IBOutlet weak var openInMapButton: UIButton!
    @IBOutlet weak var seeStationsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        let viewController = self
        let interactor = DetailInteractor()
        let presenter = DetailPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.api = api
        presenter.viewController = viewController
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetch()
    }
  
    func fetch() {
        let request = Detail.Fetch.Request(route: detailRoute)
        interactor?.fetch(request: request)
    }
  
    func displayData(data: Detail.Fetch.ViewModel?, error: Error?) {
        if let error = error {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Try Again", comment: ""), style: .default, handler: { _ in
                self.fetch()
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            guard let data = data else {
                return
            }
            title = data.name
            companyLabel.text = data.company.first
            locationLabel.text = "\(data.location.city), \(data.location.country)"
            coordinatesLabel.text = "\(data.location.coordinates.latitude), \(data.location.coordinates.longitude)"
            openInMapButton.isHidden = false
            stationsLabel.text = "\(data.stations.count)"
            if data.stations.count > 0 {
                seeStationsButton.isHidden = false
            }
            self.data = data
        }
    }
    
    @IBAction func openCoordinatesInMap(_ sender: Any) {
        guard let data = data else {
            return
        }
        let latitude: CLLocationDegrees =  data.location.coordinates.latitude
        let longitude: CLLocationDegrees =  data.location.coordinates.longitude

        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = data.name
        mapItem.openInMaps(launchOptions: options)
    }

    @IBAction func openStationsList(_ sender: Any) {
        guard let data = data else {
            return
        }
        router.goTo(.stations(stations: data.stations), from: self)
    }
}

extension DetailViewController: Routable {
    static func instantiate() -> UIViewController & Routable {
        guard let result = UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as? DetailViewController else {
            fatalError()
        }
        return result
    }

    func setup(_ route: Route) {
        switch route {
        case .detail(detailRoute: let detailRoute):
            self.route = route
            self.detailRoute = detailRoute
        default:
            fatalError()
        }
    }
}
