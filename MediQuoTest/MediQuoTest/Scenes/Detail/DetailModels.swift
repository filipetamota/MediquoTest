//
//  DetailModels.swift
//  MediQuoTest
//
//  Created by Filipe on 07/03/2020.
//  Copyright (c) 2020 Filipe Mota. All rights reserved.
//

import UIKit

enum Detail {
    // MARK: Use cases

    enum Fetch {

        enum Status {
            case loaded
            case error(Error)
        }

        struct Request {
            let route: String
        }

        struct Response {
            let status: Status
            let data: [String: Any]?
        }

        struct Coordinates {
            let latitude: Double
            let longitude: Double
        }

        struct Location {
            let city: String
            let country: String
            let coordinates: Coordinates
        }

        struct Station {
            let id: String
            let name: String
            let emptySlots: Int
            let freeBikes: Int
            let coordinates: Coordinates
        }

        struct ViewModel {
            let id: String
            let name: String
            let route: String
            let company: [String]
            let location: Location
            let stations: [Station]
        }
    }
}
