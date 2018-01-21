import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pageFactory: PageFactory?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let pageFactory = PageFactory.init(
            configuration: Configuration.global,
            cachedLoader: Client.cachedLoader)
        self.pageFactory = pageFactory
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController.init(
            rootViewController: pageFactory.getStargazersViewController(
                title: "Stargazers",
                tableViewAdapter: StargazersAdapter.init()))
        window?.makeKeyAndVisible()
        
        return true
    }
}
