//
//  AppTransitioner.swift
//  MediQuoTest
//
//  Created by Filipe on 03/03/2020.
//  Copyright © 2020 Filipe Mota. All rights reserved.
//

import UIKit

class AppTransitioner: Transitioner {
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func perform(_ transition: Transition, from presenter: UIViewController?) {
        switch transition {
        case .root(let viewController, animated: let animated):
            presentAsRoot(viewController: viewController, from: presenter, animated: animated)

        case .push(let viewController, animated: let animated):
            push(viewController: viewController, from: presenter, animated: animated)

        case .modal(let viewController, animated: let animated):
            presentAsModal(viewController: viewController, from: presenter, animated: animated)
        }
    }

    func dismissModals(completion: (() -> Void)?) {
        dismissModals(animated: true, completion: completion)
    }

    private func presentAsRoot(viewController: UIViewController, from presenter: UIViewController?, animated: Bool, completion: (() -> Void)? = nil) {

        window.rootViewController = viewController

        guard presenter != nil else {
            completion?()
            return
        }

        // animate transition
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.window.rootViewController = viewController
        },
                          completion: { (_) in
                            completion?()
        })
    }

    private func presentAsModal(viewController: UIViewController, from presenter: UIViewController?, animated: Bool) {
        let finalPresenter = presenter

        if let finalPresenter = finalPresenter {
            finalPresenter.present(viewController, animated: animated, completion: nil)
        } else {
            guard let active = activeViewController else {
                assertionFailure("Could not find the active view controller")
                return
            }

            active.present(viewController, animated: animated, completion: nil)
        }
    }

    private func push(viewController: UIViewController, from presenter: UIViewController?, animated: Bool) {
        if let nc = presenter as? UINavigationController {
            nc.pushViewController(viewController, animated: animated)
            return
        }

        if let nc = presenter?.navigationController {
            nc.pushViewController(viewController, animated: animated)
            return
        }

        fatalError()
    }

    private var activeViewController: UIViewController? {
        guard let vc = window.rootViewController else {
            return nil
        }

        var result: UIViewController = vc
        while let pvc = result.presentedViewController {
            result = pvc
        }

        return result
    }

    private func dismissModals(animated: Bool, completion: (() -> Void)?) {
        guard
            let vc = activeViewController,
            vc != window.rootViewController
        else {
            completion?()
            return
        }

        vc.dismiss(animated: animated) { [weak self] in
            self?.dismissModals(animated: animated, completion: completion)
        }
    }

}
