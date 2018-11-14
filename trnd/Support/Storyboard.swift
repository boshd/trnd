
import UIKit

enum Storyboard: String {
    
    case Onboard
    case Main
    case Settings
    case Cam
    
    
    // MARK: - Helpers
    
    fileprivate func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    
    fileprivate func viewControllerWithClass<T>(_ className: T.Type) -> T {
        let identifier = String(describing: className)
        return storyboard().instantiateViewController(withIdentifier: identifier) as! T
    }
    
    // MARK: - Onboard
    
    static func onboardNavigationController() -> OnboardNavigationController {
        return Storyboard.Onboard.viewControllerWithClass(OnboardNavigationController.self)
    }
    
    static func welcomeViewController() -> WelcomeViewController {
        return Storyboard.Onboard.viewControllerWithClass(WelcomeViewController.self)
    }
    
    static func signInViewController() -> SignInViewController {
        return Storyboard.Onboard.viewControllerWithClass(SignInViewController.self)
    }
    
    static func signUpEmailViewController() -> SignUpViewController {
        return Storyboard.Onboard.viewControllerWithClass(SignUpViewController.self)
    }
    
    static func signUpDetailsViewController() -> SignUpDetailsViewController {
        return Storyboard.Onboard.viewControllerWithClass(SignUpDetailsViewController.self)
    }
    
    // MARK: - Main

    static func mainNavigationController() -> NavigationController {
        return Storyboard.Main.viewControllerWithClass(NavigationController.self)
    }
    
    static func profileViewController() -> ProfileViewController {
        return Storyboard.Main.viewControllerWithClass(ProfileViewController.self)
    }
    
    static func searchViewController() -> SearchViewController {
        return Storyboard.Main.viewControllerWithClass(SearchViewController.self)
    }
    
    static func mainController() -> MainController {
        return Storyboard.Main.viewControllerWithClass(MainController.self)
    }
    
    static func mainControllerFirstTime() -> MainController{
        return Storyboard.Main.viewControllerWithClass(MainController.self)
        let vc = MainController()
    }
    
    static func feedViewController() -> FeedViewController {
        return Storyboard.Main.viewControllerWithClass(FeedViewController.self)
    }
    
    //static func fotoViewController() -> FotoViewController {
    //    return Storyboard.Foto.viewControllerWithClass(FotoViewController.self)
    //}
    
    static func fotoPreviewViewController() -> FotoPreviewViewController {
        return Storyboard.Cam.viewControllerWithClass(FotoPreviewViewController.self)
    }
    
    static func notificationViewController() -> NotificationViewController {
        return Storyboard.Main.viewControllerWithClass(NotificationViewController.self)
    }
    
    static func postsViewController() -> PostsViewController {
        return Storyboard.Main.viewControllerWithClass(PostsViewController.self)
    }
    
    static func followViewController() -> FollowViewController {
        return Storyboard.Main.viewControllerWithClass(FollowViewController.self)
    }
    
    static func commentViewController() -> CommentViewController {
        return Storyboard.Main.viewControllerWithClass(CommentViewController.self)
    }
    
    static func hashtagViewController() -> HashtagViewController {
        return Storyboard.Main.viewControllerWithClass(HashtagViewController.self)
    }
    
    // MARK: - Settings
    
    static func settingsViewController() -> SettingsViewController {
        return Storyboard.Settings.viewControllerWithClass(SettingsViewController.self)
    }
}
