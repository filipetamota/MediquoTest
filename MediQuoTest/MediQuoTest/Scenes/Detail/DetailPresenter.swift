//
//  DetailPresenter.swift
//  MediQuoTest
//
//  Created by Filipe on 07/03/2020.
//  Copyright (c) 2020 Filipe Mota. All rights reserved.
//

import UIKit

protocol DetailPresentationLogic {
    func presentData(response: Detail.Fetch.Response)
}

class DetailPresenter: DetailPresentationLogic {
    weak var viewController: DetailDisplayLogic?

    func presentData(response: Detail.Fetch.Response) {
        switch response.status {
        case .error(let error):
            viewController?.displayData(data: nil, error: error)
        case .loaded:
            parseResponse(response: response.data)
        }
    }

    private func parseResponse(response: [String: Any]?) {
        guard let data = response?["network"] as? [String: Any] else {
            return
        }

        guard
            let name = data["name"] as? String,
            let identifier = data["id"] as? String,
            let route = data["href"] as? String,
            let location = data["location"] as? [String: Any],
            let stations = data["stations"] as? [[String: Any]]
        else {
            fatalError()
        }
        var companyArray = [String]()
        if let company = data["company"] as? String {
            companyArray.append(company)
        } else if let company = data["company"] as? [String] {
            companyArray.append(contentsOf: company)
        }

        let vm = Detail.Fetch.ViewModel(id: identifier, name: name, route: route, company: companyArray, location: parseLocation(response: location), stations: parseStations(stations: stations))
        viewController?.displayData(data: vm, error: nil)
    }

    private func parseLocation(response: [String: Any]) -> Detail.Fetch.Location {
        guard
            let city = response["city"] as? String,
            let country = response["country"] as? String,
            let latitude = response["latitude"] as? Double,
            let longitude = response["longitude"] as? Double
        else {
            return Detail.Fetch.Location(city: "", country: "", coordinates: Detail.Fetch.Coordinates(latitude: 0, longitude: 0))
        }
        return Detail.Fetch.Location(city: city, country: country, coordinates: Detail.Fetch.Coordinates(latitude: latitude, longitude: longitude))
    }

    private func parseStations(stations: [[String: Any]]) -> [Detail.Fetch.Station] {
        var stationsArray: [Detail.Fetch.Station] = []
        for station in stations {
            guard
                let name = station["name"] as? String,
                let identifier = station["id"] as? String,
                let empty_slots = station["empty_slots"] as? Int,
                let free_bikes = station["free_bikes"] as? Int,
                let latitude = station["latitude"] as? Double,
                let longitude = station["longitude"] as? Double
            else {
                fatalError()
            }

            stationsArray.append(Detail.Fetch.Station(id: identifier, name: name, emptySlots: empty_slots, freeBikes: free_bikes, coordinates: Detail.Fetch.Coordinates(latitude: latitude, longitude: longitude)))
        }
        return stationsArray
    }
}
