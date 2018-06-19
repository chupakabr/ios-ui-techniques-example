//
//  FriendsListViewModel.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 30/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import Foundation

protocol FriendsListViewModelProtocol {
    var headerViewModel: FriendsListHeaderViewModelProtocol { get }
    var contentViewModel: FriendsListContentViewModelProtocol { get }
}

final class FriendsListViewModel: FriendsListViewModelProtocol {
    let headerViewModel: FriendsListHeaderViewModelProtocol
    let contentViewModel: FriendsListContentViewModelProtocol

    init(headerViewModel: FriendsListHeaderViewModelProtocol,
         contentViewModel: FriendsListContentViewModelProtocol) {
        self.headerViewModel = headerViewModel
        self.contentViewModel = contentViewModel
    }
}
