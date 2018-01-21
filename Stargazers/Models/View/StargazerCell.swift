import Foundation

enum StargazersPageCell {
    case loading
    case done(StargazerCell)
}

struct StargazerCell {
    var title: String
    var icon: Transitional<Data>
    
    static func withEmptyIcon(title: String) -> StargazerCell {
        return StargazerCell.init(
            title: title,
            icon: .empty)
    }
    
    var startLoadingIcon: StargazerCell {
        var m_self = self
        m_self.icon = .loading
        return m_self
    }
    
    func update(withImageData imageData: Data) -> StargazerCell {
        var m_self = self
        m_self.icon = .success(imageData)
        return m_self
    }
    
    func fail(withError error: Error) -> StargazerCell {
        var m_self = self
        m_self.icon = .failure(error)
        return m_self
    }
}
