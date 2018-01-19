@testable import Stargazers
import SwiftCheck
import Foundation

extension String.NonEmpty: Arbitrary {
    public static var arbitrary: Gen<String.NonEmpty> {
        return String.arbitrary
            .suchThat { $0.count > 0 }
            .map { String.NonEmpty.init($0)! }
    }
}

extension RequestModel.StargazersStart: Arbitrary {
    public static var arbitrary: Gen<RequestModel.StargazersStart> {
        return Gen<RequestModel.StargazersStart>.compose {
            RequestModel.StargazersStart.init(owner: $0.generate(), repo: $0.generate())
        }
    }
}

extension HeaderLink.Category: Arbitrary {
    public static var arbitrary: Gen<HeaderLink.Category> {
        return Gen<HeaderLink.Category>.fromElements(of: [.next,.last])
    }
}

extension URLComponents: Arbitrary {
    public static var arbitrary: Gen<URLComponents> {
        return Gen<URLComponents>.compose {
            var components = URLComponents.init()

            let charactersGen = Gen.fromElements(of: Array.init("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")).map(String.init)
            let stringGen = charactersGen.proliferateNonEmpty.map { $0.reduce("", +) }
            let domainGen = Gen.fromElements(of: ["com","org","it","net"])
            
            let schemeGen = Gen.fromElements(of: ["http","https"])
            let hostGen = Gen.zip(stringGen, domainGen).map { "www.\($0).\($1)" }
            let pathGen = stringGen.map { "/\($0)" }.proliferate.map { $0.reduce("", +) }
            let queryItemsGen = Gen.zip(stringGen, stringGen).map(URLQueryItem.init).proliferate
            
            components.scheme = $0.generate(using: schemeGen)
            components.host = $0.generate(using: hostGen)
            components.path = $0.generate(using: pathGen)
            components.queryItems = $0.generate(using: queryItemsGen)
            
            return components
        }
    }
}
