import UIKit

extension UseCase {
//    static func updateStargazersPage(application: Application, updatePage: Updater<StargazersPage>) {
//        switch application.state {
//        case .empty
//            updatePage { }
//        }
//    }
    
//    static func getStargazersPage(application: Application) -> StargazersPage {
//        let initial = StargazersPage.initial(title: "Stargazers")
//        let cells = application.stargazers.map { StargazerCell.withEmptyIcon(title: $0.username) }
//
//
//
//        switch application.state {
//        case .start:
//            return initial
//
//        case .loading:
//            return initial.toLoading
//
//        case .hasNextURL:
//            return initial.resetTo(cells: cells, addLoading: true)
//
//        case .hasNextURLErrored:
//            return initial.resetTo(cells: cells, addLoading: true)
//
//        case .errored(let error):
//            return initial.fail(withError: error)
//
//        case .done:
//            return initial.resetTo(cells: cells, addLoading: false)
//        }
//    }
    
    static func loadStargazerCell(
        requestFunction: @escaping RequestFunction<URL,Data>,
        updateCell: @escaping Updater<StargazerCell>)
        -> Handler<Stargazer>
    {
        return { stargazer in
            updateCell { $0.startLoadingIcon }
            
            requestFunction
                <| stargazer.avatarURL
                <| { getImage in
                    do {
                        let imageData = try getImage()
                        updateCell { $0.update(withImageData: imageData) }
                    }
                    catch let error {
                        updateCell { $0.fail(withError: error) }
                    }
            }
        }
    }
}

