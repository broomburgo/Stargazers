import UIKit

extension UseCase {
//    static func updateStargazersPage(application: Application, updatePage: Updater<StargazersPage>) {
//        switch application.state {
//        case .empty
//            updatePage { }
//        }
//    }
    
    static func loadStargazerCell(
        requestFunction: @escaping RequestFunction<URL,Data>,
        stargazer: Stargazer,
        updateCell: @escaping Updater<StargazerCell>)
    {
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

