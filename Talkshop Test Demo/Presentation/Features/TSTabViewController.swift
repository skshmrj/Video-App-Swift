//
//  TSTabViewController.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import UIKit

/// A custom tab view controller for Talkshop Test Demo app.
final class TSTabViewController: UITabBarController {
    
    /// The factory for creating other factories.
    let mainFactory: MainFactoryProtocol
    
    /// Initializes the tab view controller with a factory for creating other factories.
    ///
    /// - Parameter mainFactory: The factory for creating other factories.
    init(mainFactory: MainFactoryProtocol) {
        self.mainFactory = mainFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    /// This initializer is not implemented and will cause a runtime error if called.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    /// Configures the tab view controller.
    private func configure() {
        // Set the background color for the view.
        view.backgroundColor = AppStyle.Color.backgroundColor
        
        // Configure the appearance of the tab bar.
        configureTabBarAppearance()
        
        // Create repositories and use cases using the main factory.
        let postsRepositories = mainFactory.repositoryFactory.createPostsRepository()
        let fetchUseCase = mainFactory.useCaseFactory.createFetchPostsUseCase(repository: postsRepositories)
        
        // Create and configure the feed view controller.
        let myFeedViewController = createMyFeedViewController(viewModelFactory: mainFactory.viewModelFactory,
                                                              viewcontrollerFactory:  mainFactory.viewControllerFactory,
                                                              postsRepositories: postsRepositories,
                                                              fetchPostsUseCase: fetchUseCase)
        myFeedViewController.tabBarItem = UITabBarItem(title: "", image: UIImage.myFeed, tag: 0)
        
        // Create and configure the profile view controller.
        let myCurrentUser = User.currentUser
        let myProfileViewController = createMyProfileViewController(user: myCurrentUser,
                                                                    viewModelFactory: mainFactory.viewModelFactory,
                                                                    viewcontrollerFactory:  mainFactory.viewControllerFactory,
                                                                    postsRepositories: postsRepositories,
                                                                    fetchPostsUseCase: fetchUseCase)
        myProfileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage.myProfile, tag: 1)
        
        // Set the view controllers of the tab bar.
        setViewControllers([myFeedViewController, myProfileViewController], animated: true)
    }
    
    /// Configures the appearance of the tab bar.
    private func configureTabBarAppearance() {
        let tabBar = self.tabBar
        tabBar.tintColor = AppStyle.Color.primaryColor
        tabBar.barTintColor = AppStyle.Color.backgroundColor
    }
}

private extension TSTabViewController {
    /// Creates and returns a `MyFeedViewController`.
    ///
    /// - Parameters:
    ///   - viewModelFactory: The factory for creating view models.
    ///   - viewcontrollerFactory: The factory for creating view controllers.
    ///   - postsRepositories: The repository for fetching posts.
    ///   - fetchPostsUseCase: The use case for fetching posts.
    /// - Returns: A configured `MyFeedViewController`.
    func createMyFeedViewController(viewModelFactory: TSViewModelFactoryProtocol,
                                    viewcontrollerFactory: TSViewControllerFactoryProtocol,
                                    postsRepositories: PostsRepositoryProtocol,
                                    fetchPostsUseCase: FetchPostsUseCaseProtocol) -> MyFeedViewController {
        let myFeedViewModel = viewModelFactory.createMyFeedViewModel(fetchPostsUseCase: fetchPostsUseCase)
        let myFeedViewController = viewcontrollerFactory.createMyFeedViewController(viewModel: myFeedViewModel, mainFactory: mainFactory)
        return myFeedViewController
    }
    
    /// Creates and returns a `MyProfileViewController`.
    ///
    /// - Parameters:
    ///   - user: The current user.
    ///   - viewModelFactory: The factory for creating view models.
    ///   - viewcontrollerFactory: The factory for creating view controllers.
    ///   - postsRepositories: The repository for fetching posts.
    ///   - fetchPostsUseCase: The use case for fetching posts.
    /// - Returns: A configured `MyProfileViewController`.
    func createMyProfileViewController(user: User,
                                       viewModelFactory: TSViewModelFactoryProtocol,
                                       viewcontrollerFactory: TSViewControllerFactoryProtocol,
                                       postsRepositories: PostsRepositoryProtocol,
                                       fetchPostsUseCase: FetchPostsUseCaseProtocol) -> MyProfileViewController {
        let myProfileViewModel = viewModelFactory.createMyProfileViewModel(fetchPostsUseCase: fetchPostsUseCase, user: user)
        let myProfileViewController = viewcontrollerFactory.createMyProfileViewController(viewModel: myProfileViewModel)
        return myProfileViewController
    }
}
