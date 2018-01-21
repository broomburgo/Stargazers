import Foundation

enum StargazersPageCell {
    case loading
    case done(StargazerCell)
}

struct StargazerCell {
    var stargazer: Stargazer
    var icon: Transitional<Data>
    
    var shouldLoadIcon: Bool {
        switch icon {
        case .empty:
            return true
        case .loading:
            return false
        case .failure:
            return true
        case .success:
            return false
        }
    }
    
    static func withEmptyIcon(stargazer: Stargazer) -> StargazerCell {
        return StargazerCell.init(
            stargazer: stargazer,
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
