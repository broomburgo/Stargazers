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

extension Array {
    func getSafely(at index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

extension String: Error {}

typealias Endo<A> = (A) -> A

typealias Handler<A> = (A) -> ()

typealias Updater<A> = Handler<Endo<A>>

typealias Continuation<A> = (@escaping Handler<A>) -> ()

typealias Throwing<A> = () throws -> A

enum Transitional<A> {
    case empty
    case loading
    case success(A)
    case failure(Error)
}
