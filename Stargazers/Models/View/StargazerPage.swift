struct StargazersPage {
    var title: String
    var state: Transitional<[StargazersPageCell]>
    
    static func initial(title: String) -> StargazersPage {
        return StargazersPage.init(title: title, state: .empty)
    }
    
    func resetTo(cells: [StargazerCell], addLoading: Bool) -> StargazersPage {
        var m_self = self
        m_self.state = .success(cells.map(StargazersPageCell.done) + getLoading(when: addLoading))
        return m_self
    }
    
    func append(cells: [StargazerCell], addLoading: Bool) -> StargazersPage {
        var m_self = self
        
        switch state {
            
        case .empty, .failure, .loading:
            m_self.state = .success(cells.map(StargazersPageCell.done))
            
        case .success(let previousCells):
            let filtered = previousCells.filter {
                if case .loading = $0 {
                    return false
                } else {
                    return true
                }
            }
            
            m_self.state = .success(filtered
                + cells.map(StargazersPageCell.done)
                + getLoading(when: addLoading))
        }
        
        return m_self
    }
    
    func fail(withError error: Error) -> StargazersPage {
        var m_self = self
        m_self.state = .failure(error)
        return m_self
    }
    
    func updateCell(atIndex index: Int, update: Endo<StargazerCell>) -> StargazersPage {
        guard
            case .success(let cells) = state,
            let cell = cells.getSafely(at: index),
            case .done(let stargazerCell) = cell
            else { return self }
        
        let newStargazerCell = update(stargazerCell)
        
        var m_self = self
        
        var m_cells = cells
        m_cells.remove(at: index)
        m_cells.insert(.done(newStargazerCell), at: index)
        
        m_self.state = .success(cells)
        return m_self
    }
    
    private func getLoading(when addLoading: Bool) -> [StargazersPageCell] {
        return addLoading ? [StargazersPageCell.loading] : []
    }
}
