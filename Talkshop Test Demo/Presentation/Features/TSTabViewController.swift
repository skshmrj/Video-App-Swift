//
//  TSTabViewController.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 11/05/24.
//

import UIKit

final class TSTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .purple
        
        configureTabBarAppearance()
        
        // TODO: Use factories here
        let myFeedViewController = MyFeedViewController()
        myFeedViewController.tabBarItem = UITabBarItem(title: "My Feed", image: UIImage.myFeed, tag: 0)
        
        // TODO: Use factories here
        let myProfileViewController = MyProfileViewController()
        myProfileViewController.tabBarItem = UITabBarItem(title: "My Profile", image: UIImage.myProfile, tag: 1)
        
        setViewControllers([myFeedViewController, myProfileViewController], animated: true)
        
    }
    
    private func configureTabBarAppearance() {
        // Create a custom tab bar appearance
        let tabBar = self.tabBar
        tabBar.tintColor = UIColor.purple // Set the tint color
        tabBar.barTintColor = UIColor.black // Set the background color
        
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
