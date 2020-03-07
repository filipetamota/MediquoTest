//
//  AppRouter.swift
//  MediQuoTest
//
//  Created by Filipe on 03/03/2020.
//  Copyright © 2020 Filipe Mota. All rights reserved.
//

import UIKit

class AppRouter: NSObject, Router {

    let transitioner: Transitioner
    let apiClient: APIClient

    required init(transitioner: Transitioner) {
        self.transitioner = transitioner
        self.apiClient = AppAPIClient(baseUrl: URL(string: "http://api.citybik.es/v2/")!)
        super.init()
    }

    func goTo(_ route: Route, from presenter: UIViewController?) {

        switch route {
        case .home:
            let vc = HomeViewController.instantiate()
            configure(vc, route: route)
            let nc = UINavigationController(rootViewController: vc)
            transitioner.perform(.root(nc, animated: true), from: presenter)

        case .detail(_):
            let vc = DetailViewController.instantiate()
            configure(vc, route: route)
            transitioner.perform(.push(vc, animated: true), from: presenter)

        case .stations(_):
            let vc = StationsViewController.instantiate()
            configure(vc, route: route)
            let nc = UINavigationController(rootViewController: vc)
            transitioner.perform(.modal(nc, animated: true), from: presenter)
        }
    }

    func dismiss(_ viewController: UIViewController & Routable) {
        viewController.presentingViewController?.dismiss(animated: true, completion: nil)
    }


    private func configure(_ viewController: UIViewController, route: Route) {
        if var vc = viewController as? APIClientDependency {
            vc.api = apiClient
        }

        if viewController is Routable {
            var routable = viewController as! Routable
            routable.router = self
            routable.setup(route)
        }
    }

}
