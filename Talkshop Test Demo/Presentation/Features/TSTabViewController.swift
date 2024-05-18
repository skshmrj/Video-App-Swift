//
//  TSTabViewController.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import UIKit

/// A custom tab view controller for Talkshop Test Demo app.
final class TSTabViewController: UITabBarController {
    
    /// The factory for creating other factories
    let mainFactory: MainFactoryProtocol
    
    /// Initializes the tab view controller with a view controller factory.
    ///
    /// - Parameter mainFactory: The factory for creating other factories
    init(mainFactory: MainFactoryProtocol) {
        self.mainFactory = mainFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    /// Configures the tab view controller.
    private func configure() {
        view.backgroundColor = AppStyle.Color.backgroundColor
        
        configureTabBarAppearance()
        
        let postsRepositories = mainFactory.repositoryFactory.createPostsRepository()
        let fetchUseCase = mainFactory.useCaseFactory.createFetchPostsUseCase(repository: postsRepositories)
        
        let myFeedViewController = createMyFeedViewController(viewModelFactory: mainFactory.viewModelFactory,
                                                              viewcontrollerFactory:  mainFactory.viewControllerFactory,
                                                              postsRepositories: postsRepositories,
                                                              fetchPostsUseCase: fetchUseCase)
        myFeedViewController.tabBarItem = UITabBarItem(title: "", image: UIImage.myFeed, tag: 0)
        
        let myCurrentUser = User.currentUser
        let myProfileViewController = createMyProfileViewController(user: myCurrentUser,
                                                                    viewModelFactory: mainFactory.viewModelFactory,
                                                                    viewcontrollerFactory:  mainFactory.viewControllerFactory,
                                                                    postsRepositories: postsRepositories,
                                                                    fetchPostsUseCase: fetchUseCase)
        myProfileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage.myProfile, tag: 1)
        
        setViewControllers([myFeedViewController, myProfileViewController], animated: true)
    }
    
    /// Configures the appearance of the tab bar.
    private func configureTabBarAppearance() {
        // Create a custom tab bar appearance
        let tabBar = self.tabBar
        tabBar.tintColor = AppStyle.Color.primaryColor
        tabBar.barTintColor = AppStyle.Color.backgroundColor
    }
    
}

private extension TSTabViewController {
    func createMyFeedViewController(viewModelFactory: TSViewModelFactoryProtocol,
                                    viewcontrollerFactory: TSViewControllerFactoryProtocol,
                                    postsRepositories: PostsRepositoryProtocol,
                                    fetchPostsUseCase: FetchPostsUseCaseProtocol) -> MyFeedViewController {
        
        let myFeedViewModel = viewModelFactory.createMyFeedViewModel(fetchPostsUseCase: fetchPostsUseCase)
        let myFeedViewController = viewcontrollerFactory.createMyFeedViewController(viewModel: myFeedViewModel, mainFactory: mainFactory)
        return myFeedViewController
    }
    
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

