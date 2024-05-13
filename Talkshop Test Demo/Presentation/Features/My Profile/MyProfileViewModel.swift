//
//  MyProfileViewModel.swift
//  Talkshop Test Demo
//
//  Created by Saksham Raj on 12/05/24.
//

import Foundation
import RxSwift

struct MyProfileDataSource {
    enum Section: Hashable {
        case main
    }
    
    enum Item: Hashable {
        
    }
    
    internal struct DataSource {
        let section: Section
        let rows: [Item]
    }
}

enum MyProfileViewModelConnection {
    struct Input {
        
    }
    
    struct Output {
        let dataSource: Observable<[MyProfileDataSource.DataSource]>
    }
}

protocol MyProfileProtocol {
    func connect(input: MyProfileViewModelConnection.Input) -> MyProfileViewModelConnection.Output
}

final class MyProfileViewModel: MyProfileProtocol {
    
    let dataSource = PublishSubject<[MyProfileDataSource.DataSource]>()
    
    init() {
        
    }
    
    func connect(input: MyProfileViewModelConnection.Input) -> MyProfileViewModelConnection.Output {
        let dS: [MyProfileDataSource.DataSource] = []
        
        dataSource.onNext(dS)
        
        return MyProfileViewModelConnection.Output(dataSource: dataSource.debug("Rx:"))
    }
}
