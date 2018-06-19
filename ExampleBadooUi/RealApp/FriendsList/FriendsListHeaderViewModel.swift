//
//  FriendsListHeaderViewModel.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 31/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

final class FriendsListHeaderViewModel: FriendsListHeaderViewModelProtocol {
    let friendsCountIcon: UIImage?
    let closeButtonIcon: UIImage?
    let friendsCount: Observable<String> = Observable("0")
    var onCloseAction: VoidBlock?

    private let dataProvider: FriendsListDataProviderProtocol
    private var observers: [ObserverProtocol] = []

    init(dataProvider: FriendsListDataProviderProtocol,
         friendsCountIcon: UIImage?,
         closeButtonIcon: UIImage?) {
        self.dataProvider = dataProvider
        self.friendsCountIcon = friendsCountIcon
        self.closeButtonIcon = closeButtonIcon

        self.setupDataObservers()
    }

    private func setupDataObservers() {
        self.observers.append(self.dataProvider.totalItemsCount.observeNewAndCall { [weak self] (newCount) in
            self?.friendsCount.value = "\(newCount)"
        })
    }
}
