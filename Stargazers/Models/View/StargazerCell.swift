import Foundation

enum StargazersPageCell {
    case loading
    case stargazer(StargazerCell)
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
            return false
        case .success:
            return false
        }
    }
    
    var isLoadingIcon: Bool {
        if case .loading = icon {
            return true
        } else {
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
    
    var removeIcon: StargazerCell {
        var m_self = self
        m_self.icon = .empty
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
