//
//  Router.swift
//  MediQuoTest
//
//  Created by Filipe on 03/03/2020.
//  Copyright © 2020 Filipe Mota. All rights reserved.
//

import UIKit

protocol Routable {
    var router: Router! { get set }
    var route: Route! { get }
    func setup(_ route: Route)
    static func instantiate() -> UIViewController & Routable
}

enum Route {
    case home
}

protocol Router {
    var transitioner: Transitioner { get }
    func goTo(_ route: Route, from presenter: UIViewController?)
    func dismiss(_ viewController: UIViewController & Routable)
}
