import UIKit

class TableViewAdapter<CellModel>: NSObject {
    
    var reloadRowAnimation = UITableViewRowAnimation.none
    
    func attach(to tableView: UITableView, observeDisplayCell: @escaping (CellModel,UITableViewCell,Int) -> () = { _,_,_ in }) {
        fatalError("\(#function) must be overridden")
    }
    
    func update(with cells: [CellModel], specificIndices: [Int] = []) {
        fatalError("\(#function) must be overridden")
    }
}

final class StargazersAdapter: TableViewAdapter<StargazersPageCell>, UITableViewDataSource, UITableViewDelegate {

    private weak var tableView: UITableView? = nil
    private var observeDisplayCell: (StargazersPageCell,UITableViewCell,Int) -> () = { _,_,_ in }
    private var cells: [StargazersPageCell] = []
    
    override func attach(to tableView: UITableView, observeDisplayCell: @escaping (StargazersPageCell,UITableViewCell,Int) -> () = { _,_,_ in }) {
        self.tableView = tableView
        self.observeDisplayCell = observeDisplayCell
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func update(with cells: [StargazersPageCell], specificIndices: [Int] = []) {
        self.cells = cells
        
        if specificIndices.isEmpty {
            tableView?.reloadData()
        } else {
            let visibleIndexPaths = tableView?.indexPathsForVisibleRows ?? []
            let reloadedIndexPaths = specificIndices
                .map { IndexPath.init(row: $0, section: 0) }
                .filter(visibleIndexPaths.contains)
            
            tableView?.reloadRows(at: reloadedIndexPaths, with: reloadRowAnimation)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row].getCell(in: tableView)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cells[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        observeDisplayCell(cells[indexPath.row], cell, indexPath.row)
    }
}

extension StargazersPageCell {
    fileprivate var cellHeight: CGFloat {
        switch self {
        case .loading:
            return LoadingTableViewCell.cellHeight
        case .stargazer:
            return StargazerTableViewCell.cellHeight
        }
    }
    
    fileprivate func getCell(in tableView: UITableView) -> UITableViewCell {
        switch self {
        
        case .loading:
            return tableView
                .dequeueReusableCell(withIdentifier: LoadingTableViewCell.cellIdentifier)
                as? LoadingTableViewCell
                ?? LoadingTableViewCell.fromXIB
            
        case .stargazer(let cellModel):
            return tableView
                .dequeueReusableCell(withIdentifier: StargazerTableViewCell.cellIdentifier)
                as? StargazerTableViewCell
                ?? StargazerTableViewCell.fromXIB
                |> { $0.update(with: cellModel) }
        }
    }
}
