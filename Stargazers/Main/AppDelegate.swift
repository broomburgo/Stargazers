import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pageFactory: PageFactory?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let pageFactory = PageFactory.init(
            modelRef: Ref<(StargazersPage,[Int])>.init((StargazersPage.initial(title: "Stargazers"),[])),
            configuration: Configuration.global,
            cachedLoader: Client.cachedLoader)
        self.pageFactory = pageFactory
        
        let root = UINavigationController.init(
            rootViewController: pageFactory.getStargazersViewController(
                tableViewAdapter: StargazersAdapter.init()))
        root.navigationBar.isTranslucent = false
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = root
        window?.makeKeyAndVisible()
        
        return true
    }
}
