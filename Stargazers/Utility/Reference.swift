/// The "Ref" class encapsulates a value into a reference type, and offers basic utilites for updating the value and observing its changes via listener closures
final class Ref<T> {
    init(_ value: T) {
        self.value = value
    }
    
    func update(_ transform: Endo<T>) {
        self.value = transform(value)
    }
    
    func add(listener: AnyHashable, onNext: @escaping (T) ->()) {
        listeners[listener] = onNext
    }
    
    func remove(listener: AnyHashable) {
        listeners[listener] = nil
    }
    
    func removeAll() {
        listeners.removeAll()
    }
    
    private var value: T {
        didSet {
            listeners.values.forEach { $0(value) }
        }
    }

    private var listeners: [AnyHashable : (T) -> ()] = [:]
}
