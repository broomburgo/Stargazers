@testable import Stargazers
import SwiftCheck
import Foundation

extension CheckerArguments {
    static func with(_ left: Int, _ right: Int, _ size: Int) -> CheckerArguments {
        return CheckerArguments(
            replay: .some((StdGen(left,right),size)))
    }
}

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

let arbitraryHTTPURLResponse: Gen<HTTPURLResponse?> = Gen.zip(URLComponents.arbitrary, Int.arbitrary, DictionaryOf<String,String>.arbitrary).map { components, statusCode, headers in
    HTTPURLResponse.init(
        url: components.url!,
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: headers.getDictionary)
}

let arbitraryServerResponse: Gen<ServerResponse> = Gen.zip(OptionalOf<DictionaryOf<String,Int>>.arbitrary, arbitraryHTTPURLResponse, OptionalOf<String>.arbitrary).map { optionalDictData, optionalHTTPURLResponse, optionalStringError in
    
    let optionalData = optionalDictData.getOptional
        .map { $0.getDictionary }
        .flatMap { try? JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted) }
    let optionalError = optionalStringError.getOptional
    
    return (optionalData,optionalHTTPURLResponse,optionalError)
}





