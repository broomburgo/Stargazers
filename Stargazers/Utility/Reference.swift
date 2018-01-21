/// The "Ref" class encapsulates a value into a reference type, and exposes and emitter for observing value updates
final class Ref<T> {
    init(_ value: T) {
        self.value = value
    }
    
    let emitter = Emitter<T>.init()
    
    func update(_ transform: Endo<T>) {
        self.value = transform(value)
    }
    
    private var value: T {
        didSet {
            emitter.send(value)
        }
    }
}

/// The "Emitter" class keeps track of listeners and sends them a value when asked: it's a read-only fronted for "Ref"
final class Emitter<T> {
    func add(listener: AnyHashable, onNext: @escaping (T) ->()) {
        listeners[listener] = onNext
    }
    
    func remove(listener: AnyHashable) {
        listeners[listener] = nil
    }
    
    func removeAll() {
        listeners.removeAll()
    }
    
    private var listeners: [AnyHashable : (T) -> ()] = [:]
    
    fileprivate func send(_ value: T) {
        listeners.values.forEach { $0(value) }
    }
}
