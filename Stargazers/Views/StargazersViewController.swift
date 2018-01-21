import UIKit

final class StargazersViewController: UIViewController {
    
    @IBOutlet weak var searchBox: UIView!
    @IBOutlet weak var searchButton: UIButton! {
        didSet {
            searchButton.isEnabled = false
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableViewAdapter.attach(to: tableView) { [weak self] cellModel, cell, index in
                
                switch cellModel {
                
                case .stargazer(let model) where model.shouldLoadIcon:
                    self?.actionRef.update { _ in .loadCell(model: model, index: index) }
                
                case .loading:
                    guard let nextURL = self?.model.nextURL else { return }
                    self?.actionRef.update { _ in .nextPage(url: nextURL) }

                default:
                    break
                }
            }
        }
    }
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var errorView: UIView!
    
    @IBAction func ownerTextFieldValueChanged(sender: UITextField) {
        currentOwner = sender.text.flatMap(String.NonEmpty.init)
    }

    @IBAction func repoTextFieldValueChanged(sender: UITextField) {
        currentRepo = sender.text.flatMap(String.NonEmpty.init)
    }
    
    @IBAction func didDTapSearchButton(sender: UIButton) {
        view.endEditing(true)
        
        guard let currentOwner = currentOwner, let currentRepo = currentRepo else { return }
        
        tableView.setContentOffset(.zero, animated: false)

        actionRef.update { _ in .search(owner: currentOwner, repo: currentRepo) }
    }

    private let actionRef = Ref<Action>.init(.none)
    
    private let tableViewAdapter: TableViewAdapter<StargazersPageCell>
    
    private var model: StargazersPage {
        didSet {
            self.title = model.title
            
            switch model.state {
                
            case .empty:
                searchBox.isUserInteractionEnabled = true
                tableView.isHidden = true
                loadingView.isHidden = true
                errorView.isHidden = true
                
            case .loading:
                searchBox.isUserInteractionEnabled = false
                tableView.isHidden = true
                loadingView.isHidden = false
                errorView.isHidden = true
                
            case .failure:
                searchBox.isUserInteractionEnabled = true
                tableView.isHidden = true
                loadingView.isHidden = true
                errorView.isHidden = false
                
            case .success:
                searchBox.isUserInteractionEnabled = true
                tableView.isHidden = false
                loadingView.isHidden = true
                errorView.isHidden = true
            }
        }
    }
    
    private var currentOwner: String.NonEmpty? {
        didSet {
            updateSearchButtonEnabled()
        }
    }
    
    private var currentRepo: String.NonEmpty? {
        didSet {
            updateSearchButtonEnabled()
        }
    }
    
    private(set) lazy var actionEmitter: Emitter<Action> = self.actionRef.emitter

    init(model: StargazersPage, tableViewAdapter: TableViewAdapter<StargazersPageCell>) {
        self.model = model
        self.tableViewAdapter = tableViewAdapter
        super.init(nibName: "StargazersViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Requires proper initialization")
    }
    
    func updateModel(update: Endo<StargazersPage>, specificIndices: [Int] = []) {
        self.model = update(self.model)
        
        if case .success(let cells) = model.state {
            tableViewAdapter.update(with: cells, specificIndices: specificIndices)
        }
    }
    
    private func updateSearchButtonEnabled() {
        searchButton.isEnabled = currentOwner != nil && currentRepo != nil
    }
}

extension StargazersViewController {
    enum Action {
        case none
        case search(owner: String.NonEmpty, repo: String.NonEmpty)
        case loadCell(model: StargazerCell, index: Int)
        case nextPage(url: URL)
    }
}
