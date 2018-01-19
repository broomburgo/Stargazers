@testable import Stargazers
import XCTest
import SwiftCheck

let rightHeaderPortionGen = Gen.fromElements(of: [
    "<https://api.github.com/repositories/39000107/stargazers?page=2>; rel=\"next\"",
    "<https://api.github.com/repositories/39000107/stargazers?page=2>; rel=\"last\""
    ])

let wrongHeaderPortionGen = Gen.fromElements(of: [
    "||https://api.github.com/repositories/39000107/stargazers?page=2>; rel=\"next\"",
    "<https://api.github.com/repositories/39000107/stargazers?page=287>h; rel=\"next\"",
    "<https://api.github.com/repositories/39000107/stargazerspagefdsa=++èàà+èè2>; rel=\"next\"",
    "<https://api.github.com/repositories/39000107/stargazers?page=2>; relzzzzzzz=\"next\"",
    "<https://api.github.com/repositories/39000107/stargazers?page=2>; rel=\"ngasdfext\"",
    "<https://api.github.com/repositories/39000107/stargazers?page=2>; rel=dfassss\"next\"",
    "fgkdsagisdgfiasdihuiasduhdhhfhfhdhuudhfhuhudffdffffff",
    "<https://api.github.com/repositories/39000107/stargazers?page=2>, rel=\"next\"",
    "<https://api.github.com/repositories/39000107/stargazers?page=2> rel=\"next\""
    ])

class HeaderLinkTests: XCTestCase {
    func testHeaderLinkElementFromRightHeader() {
        property("It's always possible to generate a HeaderLink.Element from a correct header portion") <- forAll { (components: URLComponents, category: HeaderLink.Category) in
            let optionalTestURLString = components.url(relativeTo: nil)?.absoluteString
            
            return (optionalTestURLString != nil) ==> {
                let testURLString = optionalTestURLString!
                let headerStringPortion = "<\(testURLString)>; rel=\"\(category.rawValue)\""
                
                guard let model = HeaderLink.Element.init(string: headerStringPortion) else { return false }
                
                return model.url.absoluteString == testURLString
                    && model.category == category
            }
        }
    }
    
    func testHeaderLinkElementFromWrongHeader() {
        property("A wrong header portion always generates a nil HeaderLink.Element") <- forAllNoShrink(wrongHeaderPortionGen) { (portion: String) in
            HeaderLink.Element.init(string: portion) == nil
        }
    }
    
    func testHeaderLinkNilForNoHeaders() {
        property("If there's no Link header in a header dictionary, no HeaderLink is going to be generated") <- forAll { (ad: DictionaryOf<String,String>) in
            var headers = ad.getDictionary
            headers["Link"] = nil
            
            return HeaderLink.init(headers: headers) == nil
        }
    }
    
    func testHeaderLinkEmptyForWrongValue() {
        property("If there's a Link header but the value is meaningless, HeaderLink will be empty") <- forAll { (ad: DictionaryOf<String,String>) in
            var headers = ad.getDictionary
            headers["Link"] = wrongHeaderPortionGen.generate
            
            guard let headerLink = HeaderLink.init(headers: headers) else { return false }
            return headerLink.elements.count == 0
        }
    }
    
    func testHeaderLinkNonEmptyForRightValues() {
        property("HeaderLink contains elements for all the right values") <- forAll { (ad: DictionaryOf<String,String>) in
            var headers = ad.getDictionary
            headers["Link"] = "\(rightHeaderPortionGen.generate),\(rightHeaderPortionGen.generate)"
            
            guard let headerLink = HeaderLink.init(headers: headers) else { return false }
            return headerLink.elements.count == 2
        }
    }
    
    func testHeaderLinkIgnoresWrongValues() {
        property("HeaderLink contains elements for all the right values and filters wrong values") <- forAll { (ad: DictionaryOf<String,String>) in
            var headers = ad.getDictionary
            headers["Link"] = "\(rightHeaderPortionGen.generate),\(wrongHeaderPortionGen.generate),\(rightHeaderPortionGen.generate),\(wrongHeaderPortionGen.generate),\(rightHeaderPortionGen.generate)"
            
            guard let headerLink = HeaderLink.init(headers: headers) else { return false }
            return headerLink.elements.count == 3
        }
    }
}
