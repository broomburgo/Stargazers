import Foundation


/// Models the "Link" header
struct HeaderLink {
    var elements: [Element]
    
    init?(headers: [String:String]) {
        guard let linkHeader = headers["Link"] else { return nil }
        
        let split = linkHeader.split(separator: ",").map(String.init)
        
        self.elements = split.flatMap(Element.init(string:))
    }
    
    var getNext: Element? {
        return elements.first { $0.category == .next }
    }
    
    var getLast: Element? {
        return elements.first { $0.category == .last }
    }
    
    /// A single element of the "Link" header
    struct Element {
        var url: URL
        var category: Category
        
        init?(string: String) {
            let split = string.split(separator: ";").map(String.init)
            
            guard
                split.count == 2,
                let urlElement = split[0]
                    .trimmingCharacters(in: ["<",">"])
                    |> Optional.some,
                let url = URL.init(string: urlElement),
                let relKeyRange = split[1].range(of: "rel="),
                let categoryElement = split[1]
                    .replacingCharacters(in: relKeyRange, with: "")
                    .trimmingCharacters(in: [" ","\""])
                    |> Optional.some,
                let category = Category.init(rawValue: categoryElement)
                else { return nil }
            
            self.url = url
            self.category = category
        }
    }
    
    enum Category: String {
        case next
        case last
    }
}

