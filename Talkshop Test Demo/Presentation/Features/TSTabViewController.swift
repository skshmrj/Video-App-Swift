//
//  TSTabViewController.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import UIKit

/// A custom tab view controller for Talkshop Test Demo app.
final class TSTabViewController: UITabBarController {
    
    /// The factory for creating view controllers.
    let viewcontrollerFactory: TSViewControllerFactoryProtocol
    
    /// The factory for creating view models
    let viewModelFactory: TSViewModelFactoryProtocol
    
    /// The factory for creating use cases
    let useCaseFactory: UseCaseFactoryProtocol
    
    /// The factory for creating repositories
    let repositoryFactory: RepositoryFactoryProtocol
    
    /// Initializes the tab view controller with a view controller factory.
    ///
    /// - Parameter viewcontrollerFactory: The factory for creating view controllers.
    /// - Parameter viewModelFactory: The factory for creating view models
    /// - Parameter useCaseFactory: The factory for creating use cases
    /// - Parameter repositoryFactory: The factory for creating repositories
    init(viewcontrollerFactory: TSViewControllerFactoryProtocol,
         viewModelFactory: TSViewModelFactoryProtocol,
         useCaseFactory: UseCaseFactoryProtocol,
         repositoryFactory: RepositoryFactoryProtocol) {
        self.viewcontrollerFactory = viewcontrollerFactory
        self.viewModelFactory = viewModelFactory
        self.useCaseFactory = useCaseFactory
        self.repositoryFactory = repositoryFactory
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
        
        let postsRepositories = repositoryFactory.createPostsRepository()
        let fetchUseCase = useCaseFactory.createFetchPostsUseCase(repository: postsRepositories)
        let myFeedViewModel = viewModelFactory.createMyFeedViewModel(fetchPostsUseCase: fetchUseCase)
        let myFeedViewController = viewcontrollerFactory.createMyFeedViewController(viewModel: myFeedViewModel)
        myFeedViewController.tabBarItem = UITabBarItem(title: "my_feed_tab_item_title".localized, image: UIImage.myFeed, tag: 0)
        
        let myCurrentUser = User(userId: "user_A", userName: "Saksham", userProfileImage: UIImage.displayPicture)
        let myProfileViewModel = viewModelFactory.createMyProfileViewModel(fetchPostsUseCase: fetchUseCase, user: myCurrentUser)
        let myProfileViewController = viewcontrollerFactory.createMyProfileViewController(viewModel: myProfileViewModel)
        myProfileViewController.tabBarItem = UITabBarItem(title: "my_profile_tab_bar_title".localized, image: UIImage.myProfile, tag: 1)
        
        setViewControllers([myFeedViewController, myProfileViewController], animated: true)
    }
    
    /// Configures the appearance of the tab bar.
    private func configureTabBarAppearance() {
        // Create a custom tab bar appearance
        let tabBar = self.tabBar
        tabBar.tintColor = AppStyle.Color.primaryColor
        tabBar.barTintColor = AppStyle.Color.backgroundColor
        
        // Shadow
        tabBar.layer.shadowColor = UIColor.gray.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 4
        tabBar.layer.shadowOpacity = 0.5
        
        // Remove the default border
        tabBar.layer.borderWidth = 0.0
        tabBar.clipsToBounds = true
    }
    
}

