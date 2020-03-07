//
//  HomePresenter.swift
//  MediQuoTest
//
//  Created by Filipe on 03/03/2020.
//  Copyright (c) 2020 Filipe Mota. All rights reserved.
//

import UIKit

protocol HomePresentationLogic {
    func presentData(response: Home.Fetch.Response)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?

    func presentData(response: Home.Fetch.Response) {
        switch response.status {
        case .error(let error):
            viewController?.displayData(data: nil, error: error)
        case .loaded:
            parseResponse(response: response.data)
        }
    }

    private func parseResponse(response: [String: Any]?) {
        guard let data = response?["networks"] as? [[String: Any]] else {
            return
        }
        var vmArray: [Home.Fetch.ViewModel] = []
        for element in data {
            guard
                let name = element["name"] as? String,
                let identifier = element["id"] as? String,
                let route = element["href"] as? String,
                let location = element["location"] as? [String: Any]
            else {
                break
            }
            var companyArray = [String]()
            if let company = element["company"] as? String {
                companyArray.append(company)
            } else if let company = element["company"] as? [String] {
                companyArray.append(contentsOf: company)
            }

            vmArray.append(Home.Fetch.ViewModel(id: identifier, name: name, route: route, company: companyArray, location: parseLocation(response: location)))
        }
        viewController?.displayData(data: vmArray, error: nil)
    }

    private func parseLocation(response: [String: Any]) -> Home.Fetch.Location {
        guard
            let city = response["city"] as? String,
            let country = response["country"] as? String,
            let latitude = response["latitude"] as? Double,
            let longitude = response["longitude"] as? Double
        else {
            return Home.Fetch.Location(city: "", country: "", coordinates: Home.Fetch.Coordinates(latitude: 0, longitude: 0))
        }
        return Home.Fetch.Location(city: city, country: country, coordinates: Home.Fetch.Coordinates(latitude: latitude, longitude: longitude))
    }
}
