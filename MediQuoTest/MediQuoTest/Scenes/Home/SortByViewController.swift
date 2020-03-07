//
//  SortByViewController.swift
//  MediQuoTest
//
//  Created by Filipe on 07/03/2020.
//  Copyright © 2020 Filipe Mota. All rights reserved.
//

import UIKit

protocol SortByDelegate: class {
    func sortByViewController(_ viewController: SortByViewController, didChangeTo sortMethod: SortingMethod)
}

class SortByViewController: UIViewController {
    var router: Router!
    private(set) var route: Route!
    private var sortingMethod: SortingMethod!
    weak var delegate: SortByDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Sort By", comment: "")
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
        case .sortBy(method: let method, delegate: let delegate):
            self.route = route
            self.sortingMethod = method
            self.delegate = delegate
        default:
            fatalError()
        }
    }
}

extension SortByViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch SortingMethod.allValues[indexPath.row] {
        case .location, .stations:
            let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Not implemented!", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        default:
            delegate?.sortByViewController(self, didChangeTo: SortingMethod.allValues[indexPath.row])
        }

    }
}

extension SortByViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SortingMethod.allValues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell", for: indexPath)
        cell.textLabel?.text = SortingMethod.allValues[indexPath.row].title
        if SortingMethod.allValues[indexPath.row] == self.sortingMethod {
            cell.accessoryType = .checkmark
        }
        return cell
    }


}
