//
//  DetailInteractor.swift
//  MediQuoTest
//
//  Created by Filipe on 07/03/2020.
//  Copyright (c) 2020 Filipe Mota. All rights reserved.
//

import UIKit

protocol DetailBusinessLogic {
    func fetch(request: Detail.Fetch.Request)
}

class DetailInteractor: DetailBusinessLogic {
    var presenter: DetailPresentationLogic?
    var worker: DetailWorker?
    var api: APIClient!
  
  func fetch(request: Detail.Fetch.Request) {
      worker = DetailWorker(api: api)
      worker?.getNetworkDetail(request: request, completion: { (data, error) in
          if let error = error {
              let response = Detail.Fetch.Response(status: .error(error), data: nil)
              self.presenter?.presentData(response: response)
          } else {
              let response = Detail.Fetch.Response(status: .loaded, data: data)
              self.presenter?.presentData(response: response)
          }
      })
  }
}
