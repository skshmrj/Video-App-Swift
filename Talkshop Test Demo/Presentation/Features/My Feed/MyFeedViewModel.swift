//
//  MyFeedViewModel.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 12/05/24.
//

import RxSwift
import RxCocoa

struct MyFeedDataSource {
    enum Section: Hashable {
        case main
    }
    
    enum Item: Hashable {
        case myFeedCell(FeedCellContent)
    }
    
    internal struct DataSource {
        let section: Section
        let rows: [Item]
    }
}


enum MyFeedViewModelConnection {
    struct Input {
        
    }
    
    struct Output {
        let dataSource: Observable<[MyFeedDataSource.DataSource]>
    }
}


protocol MyFeedProtocol {
    func connect(input: MyFeedViewModelConnection.Input) -> MyFeedViewModelConnection.Output
}

final class MyFeedViewModel: MyFeedProtocol {
    
    let dataSource = BehaviorRelay<[MyFeedDataSource.DataSource]>(value: [])
    
    init() {
        
    }

    func connect(input: MyFeedViewModelConnection.Input) -> MyFeedViewModelConnection.Output {
        
        let dS: [MyFeedDataSource.DataSource] = [
            .init(section: .main, rows: [
                .myFeedCell(.init(title: "My First Cell"))
            ])
        ]
        
        dataSource.accept(dS)
        
        return MyFeedViewModelConnection.Output(dataSource: dataSource.debug("Rx:"))
    }
}
