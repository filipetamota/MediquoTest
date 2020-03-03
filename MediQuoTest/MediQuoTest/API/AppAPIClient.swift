//
//  AppAPIClient.swift
//  MediQuoTest
//
//  Created by Filipe on 03/03/2020.
//  Copyright © 2020 Filipe Mota. All rights reserved.
//

import Alamofire

class AppAPIClient: APIClient {

    let baseUrl: URL

    required init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }

    func get(route: String, parameters: [String: Any]?, completion: @escaping ([String: Any]?, Error?) -> Void) {
        request(route: route, method: .get, parameters: parameters, completion: completion)

    }

    private func request(route: String, method: HTTPMethod, parameters: [String: Any]?, completion: @escaping ([String: Any]?, Error?) -> Void) {

        guard let url = URL(string: route, relativeTo: baseUrl) else {
            completion(nil, NSError(domain: "Network", code: 1001, userInfo: ["description": "Invalid URL"]))
            return
        }

        let headers: HTTPHeaders = [
            "Content-Type": "application/vnd.api+json"
        ]
        let encoding: ParameterEncoding
        switch method {
        case .get: encoding = URLEncoding.default
        default: encoding = JSONEncoding.default
        }

        var dataRequest: DataRequest?

        dataRequest = Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON { (response) in
            var fullReq = dataRequest?.task?.currentRequest
            fullReq?.httpBody = dataRequest?.task?.originalRequest?.httpBody

            if let value = response.value as? [String: Any] {
                completion(value, nil)
            } else {
                completion(nil, response.error)
            }
        }
    }
}
