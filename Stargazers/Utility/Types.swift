import Foundation

extension String {
    
    /// Incapsulates a non empty string via a failable initializer
    struct NonEmpty {
        let get: String
        init?(_ value: String) {
            guard value.count > 0 else { return nil }
            self.get = value
        }
    }
}

extension String: Error {}

typealias Endo<A> = (A) -> A

typealias Handler<A> = (A) -> ()

typealias Continuation<A> = (@escaping Handler<A>) -> ()

typealias Throwing<A> = () throws -> A
