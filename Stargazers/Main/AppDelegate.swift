import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = StargazersViewController.init(
            model: .initial(title: "Stargazers"),
            tableViewAdapter: StargazersAdapter.init())
        window?.makeKeyAndVisible()
        
        return true
    }
}
