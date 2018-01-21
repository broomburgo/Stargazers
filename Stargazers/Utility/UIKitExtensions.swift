import UIKit

protocol XIBConstructible {
    static var fromXIB: Self { get }
}

extension XIBConstructible {
    static var fromXIB: Self {
        let nibName = "\(Self.self)"
        return UINib(nibName: nibName, bundle: nil)
            .instantiate(withOwner: nil, options: nil)
            .first as! Self
    }
}
