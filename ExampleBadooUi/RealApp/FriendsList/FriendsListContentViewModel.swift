//
//  FriendsListContentViewModel.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 31/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

final class FriendsListContentViewModel: FriendsListContentViewModelProtocol {

    private let dataProvider: FriendsListDataProviderProtocol

    init(dataProvider: FriendsListDataProviderProtocol) {
        self.dataProvider = dataProvider
    }

    // MARK: - FriendsListContentViewModelProtocol

    var hasMoreData: Bool {
        return self.dataProvider.hasMoreData
    }

    let isLoading = Observable(false)
    let error: Observable<Error?> = Observable(nil)
    let items: Observable<[FriendsListItemProtocol]> = Observable([])

    func item(at indexPath: IndexPath) -> FriendsListItemProtocol? {
        guard indexPath.row < self.items.value.count else { return nil }
        return self.items.value[indexPath.row]
    }

    func onItemSelected(_ item: FriendsListItemProtocol, at indexPath: IndexPath) {
        // Add your business logic here
        print("did select item at \(indexPath): \(item)")
    }

    func loadMore() {
        guard !self.isLoading.value, self.hasMoreData else { return }

        self.isLoading.value = true

        self.dataProvider.loadMore { [weak self] (newItems, error) in
            guard let sSelf = self else { return }

            sSelf.isLoading.value = false

            if let error = error {
                sSelf.error.value = error
            } else {
                sSelf.error.value = nil
                sSelf.items.value = newItems
            }
        }
    }
}
