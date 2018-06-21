//
//  FriendsListViewModelFactory.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 01/06/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

protocol FriendsListViewModelFactoryProtocol {
    func makeHeaderViewModel() -> FriendsListHeaderViewModelProtocol
    func makeContentViewModel() -> FriendsListContentViewModelProtocol
}

final class FriendsListViewModelFactory: FriendsListViewModelFactoryProtocol {

    private let dataProvider: FriendsListDataProviderProtocol

    init(dataProvider: FriendsListDataProviderProtocol) {
        self.dataProvider = dataProvider
    }

    func makeHeaderViewModel() -> FriendsListHeaderViewModelProtocol {
        let friendsCountIcon = UIImage(named: "ic_friends_count")
        let closeButtonIcon = UIImage(named: "ic_close_cross")
        let viewModel = FriendsListHeaderViewModel(dataProvider: dataProvider,
                                                   friendsCountIcon: friendsCountIcon,
                                                   closeButtonIcon: closeButtonIcon)
        return viewModel
    }

    func makeContentViewModel() -> FriendsListContentViewModelProtocol {
        let viewModel = FriendsListContentViewModel(dataProvider: dataProvider)
        return viewModel
    }
}
