import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }

    func setupTabBar() {

        let mediaLibraryVC = createNavController(vc: ViewController(), itemName: "Медиатека", itemImage: "photo.on.rectangle")
        let forYouVC = createNavController(vc: ViewController(), itemName: "Для Вас", itemImage: "heart.text.square.fill")
        let albumsVC = createNavController(vc: ViewController(), itemName: "Альбомы", itemImage: "rectangle.stack.fill")
        let searchVC = createNavController(vc: ViewController(), itemName: "Поиск", itemImage: "magnifyingglass")

        viewControllers = [mediaLibraryVC, forYouVC, albumsVC, searchVC]
    }

    func createNavController(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController {

        let item = UITabBarItem(
            title: itemName,
            image: UIImage(systemName: itemImage)?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0)),
            tag: 0)
        item.titlePositionAdjustment = .init(horizontal: 0, vertical: 5)

        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        navController.navigationBar.prefersLargeTitles = true

        return navController
    }
}
