//
//  SortByViewController.swift
//  MediQuoTest
//
//  Created by Filipe on 07/03/2020.
//  Copyright © 2020 Filipe Mota. All rights reserved.
//

import UIKit


class SortByViewController: UIViewController {
    var router: Router!
    private(set) var route: Route!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sort By"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
    }

    @objc private func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension SortByViewController: Routable {
    static func instantiate() -> UIViewController & Routable {
        guard let result = UIStoryboard(name: "SortBy", bundle: nil).instantiateInitialViewController() as? SortByViewController else {
            fatalError()
        }
        return result
    }

    func setup(_ route: Route) {
        switch route {
        case .sortBy:
            self.route = route
        default:
            fatalError()
        }
    }
}
