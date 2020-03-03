//
//  APIClient.swift
//  MediQuoTest
//
//  Created by Filipe on 03/03/2020.
//  Copyright © 2020 Filipe Mota. All rights reserved.
//

import Foundation

protocol APIClientDependency {
    var api: APIClient! {get set}
}

protocol APIClient {
    func get(route: String, parameters: [String: Any]?, completion: @escaping ([String: Any]?, Error?) -> Void)
}
