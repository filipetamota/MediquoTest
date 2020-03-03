//
//  Transitioner.swift
//  MediQuoTest
//
//  Created by Filipe on 03/03/2020.
//  Copyright © 2020 Filipe Mota. All rights reserved.
//

import UIKit

enum Transition {
    case root(UIViewController, animated: Bool)
    case push(UIViewController, animated: Bool)
    case modal(UIViewController, animated: Bool)
}

protocol Transitioner {
    var window: UIWindow {get}
    func perform(_ transition: Transition, from presenter: UIViewController?)
    func dismissModals(completion: (() -> Void)?)
}

extension Transition: Equatable {
    static func == (lhs: Transition, rhs: Transition) -> Bool {
        switch (lhs, rhs) {
        case (.root, .root): return true
        case (.push, .push): return true
        case (.modal, .modal): return true
        default: return false
        }
    }
}
