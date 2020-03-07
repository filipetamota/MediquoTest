//
//  DetailWorker.swift
//  MediQuoTest
//
//  Created by Filipe on 07/03/2020.
//  Copyright (c) 2020 Filipe Mota. All rights reserved.
//

import UIKit

class DetailWorker {
    let api: APIClient

    init(api: APIClient) {
        self.api = api
    }

    func getNetworkDetail(request: Detail.Fetch.Request, completion: @escaping ([String: Any]?, Error?) -> Void) {
        api.get(route: request.route, parameters: nil) { (response, error) in
            completion(response, error)
        }
    }
}
