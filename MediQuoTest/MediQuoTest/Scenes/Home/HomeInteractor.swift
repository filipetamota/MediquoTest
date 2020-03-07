//
//  HomeInteractor.swift
//  MediQuoTest
//
//  Created by Filipe on 03/03/2020.
//  Copyright (c) 2020 Filipe Mota. All rights reserved.
//

import UIKit

protocol HomeBusinessLogic {
    func fetch(request: Home.Fetch.Request)
}

class HomeInteractor: HomeBusinessLogic {
    var presenter: HomePresentationLogic?
    var worker: HomeWorker?
    var api: APIClient!

    func fetch(request: Home.Fetch.Request) {
        worker = HomeWorker(api: api)
        worker?.getNetworks(request: request, completion: { (data, error) in
            if let error = error {
                let response = Home.Fetch.Response(status: .error(error), data: nil)
                self.presenter?.presentData(response: response)
            } else {
                let response = Home.Fetch.Response(status: .loaded, data: data)
                self.presenter?.presentData(response: response)
            }
        })
    }
}
